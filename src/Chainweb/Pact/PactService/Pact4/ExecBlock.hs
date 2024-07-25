{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

-- |
-- Module: Chainweb.Pact.PactService.Pact4.ExecBlock
-- Copyright: Copyright © 2020 Kadena LLC.
-- License: See LICENSE file
-- Maintainers: Lars Kuhtz, Emily Pillmore, Stuart Popejoy
-- Stability: experimental
--
-- Functionality for playing block transactions.
--
module Chainweb.Pact.PactService.Pact4.ExecBlock
    ( execBlock
    , execTransactions
    , execTransactionsOnly
    , continueBlock
    , minerReward
    , toPayloadWithOutputs
    , validateChainwebTxs
    , validateHashes
    , throwCommandInvalidError
    , initModuleCacheForBlock
    , runPact4Coinbase
    , CommandInvalidError(..)
    ) where

import Control.Concurrent.MVar
import Control.DeepSeq
import Control.Exception (evaluate)
import Control.Lens
import Control.Monad
import Control.Monad.Catch
import Control.Monad.Reader
import Control.Monad.State.Strict

import qualified Data.Aeson as A
import qualified Data.ByteString.Short as SB
import Data.Decimal
import Data.List qualified as List
import Data.Default (def)
import Data.Either
import Data.Foldable (toList)
import qualified Data.HashMap.Strict as HashMap
import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as T
import Data.Vector (Vector)
import qualified Data.Vector as V

import System.IO
import System.Timeout

import Prelude hiding (lookup)
import qualified Data.Map.Strict as M

import Pact.Compile (compileExps)
import Pact.Interpreter(PactDbEnv(..))
import qualified Pact.JSON.Encode as J
import qualified Pact.Parse as P
import qualified Pact.Types.Command as P
import Pact.Types.Exp (ParsedCode(..))
import Pact.Types.ExpParser (mkTextInfo, ParseEnv(..))
import qualified Pact.Types.Hash as P
import Pact.Types.RPC
import qualified Pact.Types.Runtime as P
import qualified Pact.Types.SPV as P

import qualified Pact.Core.Names as PCore
import qualified Pact.Core.Command.Types as PCore

import Chainweb.BlockHeader
import Chainweb.BlockHeight
import Chainweb.Logger
import Chainweb.Mempool.Mempool as Mempool
import Chainweb.Miner.Pact
import Chainweb.Pact.Backend.Types
import Chainweb.Pact.Service.Types
import Chainweb.Pact.SPV
import Chainweb.Pact.Types
import Chainweb.Pact4.NoCoinbase
import qualified Chainweb.Pact4.Transaction as Pact4
import qualified Chainweb.Pact5.Transaction as Pact5
import qualified Chainweb.Pact4.TransactionExec as Pact4
import qualified Chainweb.Pact5.TransactionExec as Pact5
import qualified Chainweb.Pact4.Validations as Pact4
import qualified Chainweb.Pact5.Validations as Pact5
import Chainweb.Payload
import Chainweb.Payload.PayloadStore
import Chainweb.Time
import Chainweb.Utils hiding (check)
import Chainweb.Version
import Chainweb.Version.Guards
import Data.Coerce
import Data.Word
import GrowableVector.Lifted (Vec)
import Control.Monad.Primitive
import qualified GrowableVector.Lifted as Vec
import qualified Data.Set as S


-- | Execute a block -- only called in validate either for replay or for validating current block.
--
execBlock
    :: (CanReadablePayloadCas tbl, Logger logger)
    => BlockHeader
        -- ^ this is the current header. We may consider changing this to the parent
        -- header to avoid confusion with new block and prevent using data from this
        -- header when we should use the respective values from the parent header
        -- instead.
    -> CheckablePayload
    -> PactBlockM logger (Pact4Db logger) tbl (P.Gas, PayloadWithOutputs)
execBlock currHeader payload = do
    let plData = checkablePayloadToPayloadData payload
    dbEnv <- view psBlockDbEnv
    miner <- decodeStrictOrThrow' (_minerData $ _payloadDataMiner plData)

    -- if

    trans <- liftIO $ pact4TransactionsFromPayload
      (pact4ParserVersion v (_blockChainId currHeader) (_blockHeight currHeader))
      plData
    logger <- view (psServiceEnv . psLogger)

    -- The reference time for tx timings validation.
    --
    -- The legacy behavior is to use the creation time of the /current/ header.
    -- The new default behavior is to use the creation time of the /parent/ header.
    --
    txValidationTime <- if isGenesisBlockHeader currHeader
      then return (ParentCreationTime $ _blockCreationTime currHeader)
      else ParentCreationTime . _blockCreationTime . _parentHeader <$> view psParentHeader

    -- prop_tx_ttl_validate
    valids <- liftIO $ V.zip trans <$>
        validateChainwebTxs logger v cid dbEnv txValidationTime
            (_blockHeight currHeader) trans skipDebitGas

    case foldr handleValids [] valids of
      [] -> return ()
      errs -> throwM $ TransactionValidationException errs

    logInitCache

    !results <- go miner trans >>= throwCommandInvalidError

    let !totalGasUsed = sumOf (folded . to P._crGas) results

    pwo <- either throwM return $
      validateHashes currHeader payload miner results
    return (totalGasUsed, pwo)
  where
    blockGasLimit =
      fromIntegral <$> maxBlockGasLimit v (_blockHeight currHeader)

    logInitCache = liftPactServiceM $ do
      mc <- fmap (fmap instr . _getModuleCache) <$> use psInitCache
      logDebug $ "execBlock: initCache: " <> sshow mc

    instr (md,_) = preview (P._MDModule . P.mHash) $ P._mdModule md

    handleValids (tx,Left e) es = (P._cmdHash tx, sshow e):es
    handleValids _ es = es

    v = _chainwebVersion currHeader
    cid = _chainId currHeader

    isGenesisBlock = isGenesisBlockHeader currHeader

    go m txs = if isGenesisBlock
      then
        -- GENESIS VALIDATE COINBASE: Reject bad coinbase, use date rule for precompilation
        execTransactions True m txs
          (EnforceCoinbaseFailure True) (CoinbaseUsePrecompiled False) blockGasLimit Nothing
      else
        -- VALIDATE COINBASE: back-compat allow failures, use date rule for precompilation
        execTransactions False m txs
          (EnforceCoinbaseFailure False) (CoinbaseUsePrecompiled False) blockGasLimit Nothing

throwCommandInvalidError
    :: Transactions Pact4 (Either CommandInvalidError a)
    -> PactBlockM logger (Pact4Db logger) tbl (Transactions Pact4 a)
throwCommandInvalidError = (transactionPairs . traverse . _2) throwGasFailure
  where
    throwGasFailure = \case
      Left (CommandInvalidGasPurchaseFailure e) -> throwM (BuyGasFailure e)

      -- this should be impossible because we don't
      -- set tx time limits in validateBlock
      Left (CommandInvalidTxTimeout t) -> throwM t

      Right r -> pure r

-- | The principal validation logic for groups of Pact Transactions.
--
-- Skips validation for genesis transactions, since gas accounts, etc. don't
-- exist yet.
--
validateChainwebTxs
    :: (Logger logger)
    => logger
    -> ChainwebVersion
    -> ChainId
    -> CurrentBlockDbEnv logger (Pact4Db logger)
    -> ParentCreationTime
        -- ^ reference time for tx validation.
    -> BlockHeight
        -- ^ Current block height
    -> Vector Pact4.Transaction
    -> RunGas
    -> IO ValidateTxs
validateChainwebTxs logger v cid dbEnv txValidationTime bh txs doBuyGas
  | bh == genesisHeight v cid = pure $! V.map Right txs
  | V.null txs = pure V.empty
  | otherwise = go
  where
    go = V.mapM validations initTxList >>= doBuyGas

    validations t =
      runValid checkUnique t
      >>= runValid checkTxHash
      >>= runValid checkTxSigs
      >>= runValid checkTimes
      >>= runValid (return . checkCompile v cid bh)

    checkUnique :: Pact4.Transaction -> IO (Either InsertError Pact4.Transaction)
    checkUnique t = do
      found <- HashMap.lookup (P._cmdHash t) <$> _cpLookupProcessedTx dbEnv (V.singleton $ P._cmdHash t)
      case found of
        Nothing -> pure $ Right t
        Just _ -> pure $ Left InsertErrorDuplicate

    checkTimes :: Pact4.Transaction -> IO (Either InsertError Pact4.Transaction)
    checkTimes t
        | skipTxTimingValidation v cid bh =
          return $ Right t
        | not (Pact4.assertTxNotInFuture txValidationTime (Pact4.payloadObj <$> t)) =
          return $ Left InsertErrorTimeInFuture
        | not (Pact4.assertTxTimeRelativeToParent txValidationTime (Pact4.payloadObj <$> t)) =
          return $ Left InsertErrorTTLExpired
        | otherwise =
          return $ Right t

    checkTxHash :: Pact4.Transaction -> IO (Either InsertError Pact4.Transaction)
    checkTxHash t =
        case P.verifyHash (P._cmdHash t) (SB.fromShort $ Pact4.payloadBytes $ P._cmdPayload t) of
            Left _
                | doCheckTxHash v cid bh -> return $ Left InsertErrorInvalidHash
                | otherwise -> do
                    logDebug_ logger "ignored legacy tx-hash failure"
                    return $ Right t
            Right _ -> pure $ Right t


    checkTxSigs :: Pact4.Transaction -> IO (Either InsertError Pact4.Transaction)
    checkTxSigs t
      | Pact4.assertValidateSigs validSchemes webAuthnPrefixLegal hsh signers sigs = pure $ Right t
      | otherwise = return $ Left InsertErrorInvalidSigs
      where
        hsh = P._cmdHash t
        sigs = P._cmdSigs t
        signers = P._pSigners $ Pact4.payloadObj $ P._cmdPayload t
        validSchemes = validPPKSchemes v cid bh
        webAuthnPrefixLegal = isWebAuthnPrefixLegal v cid bh

    initTxList :: ValidateTxs
    initTxList = V.map Right txs

    runValid :: Monad m => (a -> m (Either e a)) -> Either e a -> m (Either e a)
    runValid f (Right r) = f r
    runValid _ l@Left{} = pure l


type ValidateTxs = Vector (Either InsertError Pact4.Transaction)
type RunGas = ValidateTxs -> IO ValidateTxs

checkCompile
  :: ChainwebVersion
  -> ChainId
  -> BlockHeight
  -> Pact4.Transaction
  -> Either InsertError Pact4.Transaction
checkCompile v cid bh tx = case payload of
  Exec (ExecMsg parsedCode _) ->
    case compileCode parsedCode of
      Left perr -> Left $ InsertErrorCompilationFailed (sshow perr)
      Right _ -> Right tx
  _ -> Right tx
  where
    payload = P._pPayload $ Pact4.payloadObj $ P._cmdPayload tx
    compileCode p =
      let e = ParseEnv (chainweb216Pact v cid bh)
      in compileExps e (mkTextInfo (P._pcCode p)) (P._pcExps p)

skipDebitGas :: RunGas
skipDebitGas = return

execTransactions
    :: (Logger logger)
    => Bool
    -> Miner
    -> Vector Pact4.Transaction
    -> EnforceCoinbaseFailure
    -> CoinbaseUsePrecompiled
    -> Maybe P.Gas
    -> Maybe Micros
    -> PactBlockM logger (Pact4Db logger) tbl (Transactions Pact4 (Either CommandInvalidError (P.CommandResult [P.TxLogJson])))
execTransactions isGenesis miner ctxs enfCBFail usePrecomp gasLimit timeLimit = do
    mc <- initModuleCacheForBlock isGenesis
    -- for legacy reasons (ask Emily) we don't use the module cache resulting
    -- from coinbase to run the pact cmds
    coinOut <- runPact4Coinbase isGenesis miner enfCBFail usePrecomp mc
    T2 txOuts _mcOut <- applyPactCmds isGenesis ctxs miner mc gasLimit timeLimit
    return $! Transactions (V.zip ctxs txOuts) coinOut

execTransactionsOnly
    :: (Logger logger)
    => Miner
    -> Vector Pact4.Transaction
    -> ModuleCache
    -> Maybe Micros
    -> PactBlockM logger (Pact4Db logger) tbl
       (T2 (Vector (Pact4.Transaction, Either CommandInvalidError (P.CommandResult [P.TxLogJson]))) ModuleCache)
execTransactionsOnly miner ctxs mc txTimeLimit = do
    T2 txOuts mcOut <- applyPactCmds False ctxs miner mc Nothing txTimeLimit
    return $! T2 (V.force (V.zip ctxs txOuts)) mcOut

initModuleCacheForBlock :: (Logger logger) => Bool -> PactBlockM logger (Pact4Db logger) tbl ModuleCache
initModuleCacheForBlock isGenesis = do
  PactServiceState{..} <- get
  pbh <- views psParentHeader (_blockHeight . _parentHeader)
  l <- view (psServiceEnv . psLogger)
  dbEnv <- view psBlockDbEnv
  txCtx <- getTxContext noMiner def
  case Map.lookupLE pbh _psInitCache of
    Nothing -> if isGenesis
      then return mempty
      else do
        mc <- Pact4.readInitModules
        updateInitCacheM mc
        return mc
    Just (_,mc) -> pure mc

runPact4Coinbase
    :: (Logger logger)
    => Bool
    -> Miner
    -> EnforceCoinbaseFailure
    -> CoinbaseUsePrecompiled
    -> ModuleCache
    -> PactBlockM logger (Pact4Db logger) tbl (P.CommandResult [P.TxLogJson])
runPact4Coinbase True _ _ _ _ = return noCoinbase
runPact4Coinbase False miner enfCBFail usePrecomp mc = do
    logger <- view (psServiceEnv . psLogger)
    rs <- view (psServiceEnv . psMinerRewards)
    v <- view chainwebVersion
    txCtx <- getTxContext miner def

    let !bh = ctxCurrentBlockHeight txCtx

    reward <- liftIO $! minerReward v rs bh
    dbEnv <- view psBlockDbEnv
    let pactDb = _cpPactDbEnv dbEnv

    T2 cr upgradedCacheM <-
        liftIO $ Pact4.applyCoinbase v logger pactDb reward txCtx enfCBFail usePrecomp mc
    mapM_ upgradeInitCache upgradedCacheM
    liftPactServiceM $ debugResult "runPact4Coinbase" (P.crLogs %~ fmap J.Array $ cr)
    return $! cr

  where
    upgradeInitCache newCache = do
      liftPactServiceM $ logInfo "Updating init cache for upgrade"
      updateInitCacheM newCache


data CommandInvalidError
  = CommandInvalidGasPurchaseFailure !GasPurchaseFailure
  | CommandInvalidTxTimeout !TxTimeout

-- | Apply multiple Pact commands, incrementing the transaction Id for each.
-- The output vector is in the same order as the input (i.e. you can zip it
-- with the inputs.)
applyPactCmds
    :: forall logger tbl. (Logger logger)
    => Bool
    -> Vector Pact4.Transaction
    -> Miner
    -> ModuleCache
    -> Maybe P.Gas
    -> Maybe Micros
    -> PactBlockM logger (Pact4Db logger) tbl (T2 (Vector (Either CommandInvalidError (P.CommandResult [P.TxLogJson]))) ModuleCache)
applyPactCmds isGenesis cmds miner startModuleCache blockGas txTimeLimit = do
    let txsGas txs = fromIntegral $ sumOf (traversed . _Right . to P._crGas) txs
    (txOuts, T2 mcOut _) <- tracePactBlockM' "applyPactCmds" () (txsGas . fst) $
      flip runStateT (T2 startModuleCache blockGas) $
        go [] (V.toList cmds)
    return $! T2 (V.fromList . List.reverse $ txOuts) mcOut
  where
    go
      :: [Either CommandInvalidError (P.CommandResult [P.TxLogJson])]
      -> [Pact4.Transaction]
      -> StateT
          (T2 ModuleCache (Maybe P.Gas))
          (PactBlockM logger (Pact4Db logger) tbl)
          [Either CommandInvalidError (P.CommandResult [P.TxLogJson])]
    go !acc = \case
        [] -> do
            pure acc
        tx : rest -> do
            r <- applyPactCmd isGenesis miner txTimeLimit tx
            case r of
                Left e@(CommandInvalidTxTimeout _) -> do
                    pure (Left e : acc)
                Left e@(CommandInvalidGasPurchaseFailure _) -> do
                    go (Left e : acc) rest
                Right a -> do
                    go (Right a : acc) rest

applyPactCmd
  :: (Logger logger)
  => Bool
  -> Miner
  -> Maybe Micros
  -> Pact4.Transaction
  -> StateT
      (T2 ModuleCache (Maybe P.Gas))
      (PactBlockM logger (Pact4Db logger) tbl)
      (Either CommandInvalidError (P.CommandResult [P.TxLogJson]))
applyPactCmd isGenesis miner txTimeLimit cmd = StateT $ \(T2 mcache maybeBlockGasRemaining) -> do
  dbEnv <- view psBlockDbEnv
  let pactDb = _cpPactDbEnv dbEnv
  prevBlockState <- liftIO $ fmap _benvBlockState $
    readMVar $ pdPactDbVar pactDb
  logger <- view (psServiceEnv . psLogger)
  gasLogger <- view (psServiceEnv . psGasLogger)
  gasModel <- view (psServiceEnv . psGasModel)
  txFailuresCounter <- view (psServiceEnv . psTxFailuresCounter)
  v <- view chainwebVersion
  let
    -- for errors so fatal that the tx doesn't make it in the block
    onFatalError e
      | Just (BuyGasFailure f) <- fromException e = pure (Left (CommandInvalidGasPurchaseFailure f), T2 mcache maybeBlockGasRemaining)
      | Just t@(TxTimeout {}) <- fromException e = do
        -- timeouts can occur at any point during the transaction, even after
        -- gas has been bought (or even while gas is being redeemed, after the
        -- transaction proper is done). therefore we need to revert the block
        -- state ourselves if it happens.
        liftIO $ P.modifyMVar'
          (pdPactDbVar pactDb)
          (benvBlockState .~ prevBlockState)
        pure (Left (CommandInvalidTxTimeout t), T2 mcache maybeBlockGasRemaining)
      | otherwise = throwM e
    requestedTxGasLimit = view Pact4.cmdGasLimit (Pact4.payloadObj <$> cmd)
    -- notice that we add 1 to the remaining block gas here, to distinguish the
    -- cases "tx used exactly as much gas remained in the block" (which is fine)
    -- and "tx attempted to use more gas than remains in the block" (which is
    -- illegal). for example: tx has a tx gas limit of 10000. the block has 5000
    -- remaining gas. therefore the tx is applied with a tx gas limit of 5001.
    -- if it uses 5001, that's illegal; if it uses 5000 or less, that's legal.
    newTxGasLimit = case maybeBlockGasRemaining of
      Nothing -> requestedTxGasLimit
      Just blockGasRemaining -> min (fromIntegral (succ blockGasRemaining)) requestedTxGasLimit
    gasLimitedCmd =
      set Pact4.cmdGasLimit newTxGasLimit (Pact4.payloadObj <$> cmd)
    initialGas = Pact4.initialGasOf (P._cmdPayload cmd)
  let !hsh = P._cmdHash cmd

  handle onFatalError $ do
    T2 result mcache' <- do
      txCtx <- getTxContext miner (Pact4.publicMetaOf gasLimitedCmd)
      if isGenesis
      then liftIO $! Pact4.applyGenesisCmd logger pactDb P.noSPVSupport txCtx gasLimitedCmd
      else do
        bhdb <- view (psServiceEnv . psBlockHeaderDb)
        parent <- view psParentHeader
        let spv = pactSPV bhdb (_parentHeader parent)
        let
          !timeoutError = TxTimeout (requestKeyToTransactionHash $ P.cmdToRequestKey cmd)
          txTimeout = case txTimeLimit of
            Nothing -> id
            Just limit ->
               maybe (throwM timeoutError) return <=< timeout (fromIntegral limit)
          txGas (T3 r _ _) = fromIntegral $ P._crGas r
        T3 r c _warns <- do
          -- TRACE.traceShowM ("applyPactCmd.CACHE: ", LHM.keys $ _getModuleCache mcache, M.keys $ _getCoreModuleCache cmcache)
          tracePactBlockM' "applyCmd" (J.toJsonViaEncode hsh) txGas $ do
            liftIO $ txTimeout $
              Pact4.applyCmd v logger gasLogger txFailuresCounter pactDb miner (gasModel txCtx) txCtx spv gasLimitedCmd initialGas mcache ApplySend
        pure $ T2 r c

    if isGenesis
    then updateInitCacheM mcache'
    else liftPactServiceM $ debugResult "applyPactCmd" (P.crLogs %~ fmap J.Array $ result)

    -- mark the tx as processed at the checkpointer.
    liftIO $ _cpRegisterProcessedTx dbEnv hsh
    case maybeBlockGasRemaining of
      Just blockGasRemaining ->
        when (P._crGas result >= succ blockGasRemaining) $
          -- this tx attempted to consume more gas than remains in the
          -- block, so the block is invalid. we don't know how much gas it
          -- would've consumed, because we stop early, so we guess that it
          -- needed its entire original gas limit.
          throwM $ BlockGasLimitExceeded (blockGasRemaining - fromIntegral requestedTxGasLimit)
      Nothing -> return ()
    let maybeBlockGasRemaining' = (\g -> g - P._crGas result) <$> maybeBlockGasRemaining
    pure (Right result, T2 mcache' maybeBlockGasRemaining')

pact4TransactionsFromPayload
    :: Pact4.PactParserVersion
    -> PayloadData
    -> IO (Vector Pact4.Transaction)
pact4TransactionsFromPayload ppv plData = do
    vtrans <- fmap V.fromList $
              mapM toCWTransaction $
              toList (_payloadDataTransactions plData)
    let (theLefts, theRights) = partitionEithers $ V.toList vtrans
    unless (null theLefts) $ do
        let ls = map T.pack theLefts
        throwM $ TransactionDecodeFailure $ "Failed to decode pact transactions: "
            <> T.intercalate ". " ls
    return $! V.fromList theRights
  where
    toCWTransaction bs = evaluate (force (codecDecode (Pact4.payloadCodec ppv) $
                                          _transactionBytes bs))

debugResult :: J.Encode a => Logger logger => Text -> a -> PactServiceM logger tbl ()
debugResult msg result =
  logDebug $ trunc $ msg <> " result: " <> J.encodeText result
  where
    trunc t | T.length t < limit = t
            | otherwise = T.take limit t <> " [truncated]"
    limit = 5000


-- | Calculate miner reward. We want this to error hard in the case where
-- block times have finally exceeded the 120-year range. Rewards are calculated
-- at regular blockheight intervals.
--
-- See: 'rewards/miner_rewards.csv'
--
minerReward
    :: ChainwebVersion
    -> MinerRewards
    -> BlockHeight
    -> IO P.ParsedDecimal
minerReward v (MinerRewards rs) bh =
    case Map.lookupGE bh rs of
      Nothing -> err
      Just (_, m) -> pure $! P.ParsedDecimal (roundTo 8 (m / n))
  where
    !n = int . order $ chainGraphAt v bh
    err = internalError "block heights have been exhausted"
{-# INLINE minerReward #-}


data CRLogPair = CRLogPair P.Hash [P.TxLogJson]



instance J.Encode CRLogPair where
  build (CRLogPair h logs) = J.object
    [ "hash" J..= h
    , "rawLogs" J..= J.Array logs
    ]
  {-# INLINE build #-}

validateHashes
    :: BlockHeader
        -- ^ Current Header
    -> CheckablePayload
    -> Miner
    -> Transactions Pact4 (P.CommandResult [P.TxLogJson])
    -> Either PactException PayloadWithOutputs
validateHashes bHeader payload miner transactions =
    if newHash == prevHash
      then Right pwo
      else Left $ BlockValidationFailure $ BlockValidationFailureMsg $
        J.encodeJsonText $ J.object
            [ "header" J..= J.encodeWithAeson (ObjectEncoded bHeader)
            , "mismatch" J..= errorMsg "Payload hash" prevHash newHash
            , "details" J..= details
            ]
  where

    pwo = toPayloadWithOutputs Pact4T miner transactions

    newHash = _payloadWithOutputsPayloadHash pwo
    prevHash = _blockPayloadHash bHeader

    -- The following JSON encodings are used in the BlockValidationFailure message

    check :: Eq a => A.ToJSON a => T.Text -> [Maybe J.KeyValue] -> a -> a -> Maybe J.Builder
    check desc extra expect actual
        | expect == actual = Nothing
        | otherwise = Just $ J.object
            $ "mismatch" J..= errorMsg desc expect actual
            : extra

    errorMsg :: A.ToJSON a => T.Text -> a -> a -> J.Builder
    errorMsg desc expect actual = J.object
        [ "type" J..= J.text desc
        , "actual" J..= J.encodeWithAeson actual
        , "expected" J..= J.encodeWithAeson expect
        ]

    details = case payload of
        CheckablePayload pData -> J.Array $ catMaybes
            [ check "Miner"
                []
                (_payloadDataMiner pData)
                (_payloadWithOutputsMiner pwo)
            , check "TransactionsHash"
                [ "txs" J..?=
                    (J.Array <$> traverse (uncurry $ check "Tx" []) (zip
                      (toList $ fst <$> _payloadWithOutputsTransactions pwo)
                      (toList $ _payloadDataTransactions pData)
                    ))
                ]
                (_payloadDataTransactionsHash pData)
                (_payloadWithOutputsTransactionsHash pwo)
            , check "OutputsHash"
                [ "outputs" J..= J.object
                    [ "coinbase" J..= toPairCR (_transactionCoinbase transactions)
                    , "txs" J..= J.array (addTxOuts <$> _transactionPairs transactions)
                    ]
                ]
                (_payloadDataOutputsHash pData)
                (_payloadWithOutputsOutputsHash pwo)
            ]

        CheckablePayloadWithOutputs localPwo -> J.Array $ catMaybes
            [ check "Miner"
                []
                (_payloadWithOutputsMiner localPwo)
                (_payloadWithOutputsMiner pwo)
            , Just $ J.object
              [ "transactions" J..= J.object
                  [ "txs" J..?=
                      (J.Array <$> traverse (uncurry $ check "Tx" []) (zip
                        (toList $ _payloadWithOutputsTransactions pwo)
                        (toList $ _payloadWithOutputsTransactions localPwo)
                      ))
                  , "coinbase" J..=
                      check "Coinbase" []
                        (_payloadWithOutputsCoinbase pwo)
                        (_payloadWithOutputsCoinbase localPwo)
                  ]
              ]
            ]

    addTxOuts :: (Pact4.Transaction, P.CommandResult [P.TxLogJson]) -> J.Builder
    addTxOuts (tx,cr) = J.object
        [ "tx" J..= fmap (fmap _pcCode . Pact4.payloadObj) tx
        , "result" J..= toPairCR cr
        ]

    toPairCR cr = over (P.crLogs . _Just)
        (CRLogPair (fromJuste $ P._crLogs (toHashCommandResult cr))) cr

type GrowableVec = Vec (PrimState IO)

-- | Continue adding transactions to an existing block.
continueBlock
    :: forall logger tbl
    . (Logger logger, CanReadablePayloadCas tbl)
    => MemPoolAccess
    -> BlockInProgress Pact4
    -> PactBlockM logger (Pact4Db logger) tbl (BlockInProgress Pact4)
continueBlock mpAccess blockInProgress = do
    updateMempool
    liftPactServiceM $
      logInfo $ "(parent height = " <> sshow pHeight <> ")"
            <> " (parent hash = " <> sshow pHash <> ")"

    blockDbEnv <- view psBlockDbEnv
    let pactDb = _cpPactDbEnv blockDbEnv
    -- restore the block state from the block being continued
    liftIO $
      modifyMVar_ (pdPactDbVar pactDb) $ \blockEnv ->
        return
          $! blockEnv
          & benvBlockState . bsPendingBlock .~ _blockInProgressPendingData blockInProgress
          & benvBlockState . bsTxId .~ _blockInProgressTxId blockInProgress

    blockGasLimit <- view (psServiceEnv . psBlockGasLimit)

    let
        txTimeHeadroomFactor :: Double
        txTimeHeadroomFactor = 5
        -- 2.5 microseconds per unit gas
        txTimeLimit :: Micros
        txTimeLimit = round $ (2.5 * txTimeHeadroomFactor) * fromIntegral blockGasLimit

    let Pact4ModuleCache initCache = _blockInProgressModuleCache blockInProgress
    let cb = _transactionCoinbase (_blockInProgressTransactions blockInProgress)
    let startTxs = _transactionPairs (_blockInProgressTransactions blockInProgress)

    successes <- liftIO $ Vec.fromFoldable startTxs
    failures <- liftIO $ Vec.new @_ @_ @TransactionHash

    let initState = BlockFill
          (_blockInProgressRemainingGasLimit blockInProgress)
          (S.fromList $ requestKeyToTransactionHash . P._crReqKey . snd <$> V.toList startTxs)
          0

    -- Heuristic: limit fetches to count of 1000-gas txs in block.
    let fetchLimit = fromIntegral $ blockGasLimit `div` 1000
    T2
      finalModuleCache
      BlockFill { _bfTxHashes = requestKeys, _bfGasLimit = finalGasLimit }
      <- refill fetchLimit txTimeLimit successes failures initCache initState

    liftPactServiceM $ logInfo $ "(request keys = " <> sshow requestKeys <> ")"

    liftIO $ do
      txHashes <- Vec.toLiftedVector failures
      mpaBadlistTx mpAccess txHashes

    txs <- liftIO $ Vec.toLiftedVector successes
    -- edmund: we need to be careful about timeouts.
    -- If a tx times out, it must not be in the block state, otherwise
    -- the "block in progress" will contain pieces of state from that tx.
    --
    -- this cannot happen now because applyPactCmd doesn't let it.
    finalBlockState <- fmap _benvBlockState
      $ liftIO
      $ readMVar
      $ pdPactDbVar
      $ pactDb
    let !blockInProgress' = BlockInProgress
            { _blockInProgressModuleCache = Pact4ModuleCache finalModuleCache
            , _blockInProgressPendingData = _bsPendingBlock finalBlockState
            , _blockInProgressTxId = _bsTxId finalBlockState
            , _blockInProgressParentHeader = newBlockParent
            , _blockInProgressRemainingGasLimit = finalGasLimit
            , _blockInProgressTransactions = Transactions
                { _transactionCoinbase = cb
                , _transactionPairs = txs
                }
            , _blockInProgressMiner = _blockInProgressMiner blockInProgress
            , _blockInProgressPactVersion = Pact4T
            }
    return blockInProgress'
  where
    newBlockParent = _blockInProgressParentHeader blockInProgress

    !parentTime =
      ParentCreationTime (_blockCreationTime $ _parentHeader newBlockParent)

    getBlockTxs :: BlockFill -> PactBlockM logger (Pact4Db logger) tbl (Vector Pact4.Transaction)
    getBlockTxs bfState = do
      dbEnv <- view psBlockDbEnv
      psEnv <- ask
      logger <- view (psServiceEnv . psLogger)
      let validate bhi _bha txs = do
            results <- do
                let v = _chainwebVersion psEnv
                    cid = _chainId psEnv
                validateChainwebTxs logger v cid dbEnv parentTime bhi txs return

            V.forM results $ \case
                Right _ -> return True
                Left _e -> return False

      liftIO $!
        mpaGetBlock mpAccess bfState validate (pHeight + 1) pHash (_parentHeader newBlockParent)

    refill
      :: Word64
      -> Micros
      -> GrowableVec (Pact4.Transaction, P.CommandResult [P.TxLogJson])
      -> GrowableVec TransactionHash
      -> ModuleCache -> BlockFill
      -> PactBlockM logger (Pact4Db logger) tbl (T2 ModuleCache BlockFill)
    refill fetchLimit txTimeLimit successes failures = go
      where
        go :: ModuleCache -> BlockFill -> PactBlockM logger (Pact4Db logger) tbl (T2 ModuleCache BlockFill)
        go mc unchanged@bfState = do

          case unchanged of
            BlockFill g _ c -> do
              (goodLength, badLength) <- liftIO $ (,) <$> Vec.length successes <*> Vec.length failures
              liftPactServiceM $ logDebug $ "Block fill: count=" <> sshow c
                <> ", gaslimit=" <> sshow g <> ", good="
                <> sshow goodLength <> ", bad=" <> sshow badLength

              -- LOOP INVARIANT: limit absolute recursion count
              if _bfCount bfState > fetchLimit then liftPactServiceM $ do
                logInfo $ "Refill fetch limit exceeded (" <> sshow fetchLimit <> ")"
                pure (T2 mc unchanged)
              else do
                when (_bfGasLimit bfState < 0) $
                  throwM $ MempoolFillFailure $ "Internal error, negative gas limit: " <> sshow bfState

                if _bfGasLimit bfState == 0 then pure (T2 mc unchanged) else do

                  newTrans <- getBlockTxs bfState
                  if V.null newTrans then pure (T2 mc unchanged) else do

                    T2 pairs mc' <- execTransactionsOnly
                      (_blockInProgressMiner blockInProgress)
                      newTrans
                      mc
                      (Just txTimeLimit)

                    oldSuccessesLength <- liftIO $ Vec.length successes

                    (newState, timedOut) <- splitResults successes failures unchanged (V.toList pairs)

                    -- LOOP INVARIANT: gas must not increase
                    when (_bfGasLimit newState > _bfGasLimit bfState) $
                      throwM $ MempoolFillFailure $ "Gas must not increase: " <> sshow (bfState,newState)

                    newSuccessesLength <- liftIO $ Vec.length successes
                    let addedSuccessCount = newSuccessesLength - oldSuccessesLength

                    if timedOut
                    then
                      -- a transaction timed out, so give up early and make the block
                      pure (T2 mc' (incCount newState))
                    else if (_bfGasLimit newState >= _bfGasLimit bfState) && addedSuccessCount > 0
                    then
                      -- INVARIANT: gas must decrease if any transactions succeeded
                      throwM $ MempoolFillFailure
                        $ "Invariant failure, gas did not decrease: "
                        <> sshow (bfState,newState,V.length newTrans,addedSuccessCount)
                    else
                      go mc' (incCount newState)

    incCount :: BlockFill -> BlockFill
    incCount b = over bfCount succ b

    -- | Split the results of applying each command into successes and failures,
    --   and return the final 'BlockFill'.
    --
    --   If we encounter a 'TxTimeout', we short-circuit, and only return
    --   what we've put into the block before the timeout. We also report
    --   that we timed out, so that `refill` can stop early.
    --
    --   The failed txs are later badlisted.
    splitResults :: ()
      => GrowableVec (Pact4.Transaction, P.CommandResult [P.TxLogJson])
      -> GrowableVec TransactionHash -- ^ failed txs
      -> BlockFill
      -> [(Pact4.Transaction, Either CommandInvalidError (P.CommandResult [P.TxLogJson]))]
      -> PactBlockM logger (Pact4Db logger) tbl (BlockFill, Bool)
    splitResults successes failures = go
      where
        go acc@(BlockFill g rks i) = \case
          [] -> pure (acc, False)
          (t, r) : rest -> case r of
            Right cr -> do
              !rks' <- enforceUnique rks (requestKeyToTransactionHash $ P._crReqKey cr)
              -- Decrement actual gas used from block limit
              let !g' = g - fromIntegral (P._crGas cr)
              liftIO $ Vec.push successes (t, cr)
              go (BlockFill g' rks' i) rest
            Left (CommandInvalidGasPurchaseFailure (Pact4GasPurchaseFailure h _)) -> do
              !rks' <- enforceUnique rks h
              -- Gas buy failure adds failed request key to fail list only
              liftIO $ Vec.push failures h
              go (BlockFill g rks' i) rest
            Left (CommandInvalidGasPurchaseFailure (Pact5GasPurchaseFailure h _)) ->
              error "Pact5GasPurchaseFailure"
            Left (CommandInvalidTxTimeout (TxTimeout h)) -> do
              liftIO $ Vec.push failures h
              liftPactServiceM $ logError $ "timed out on " <> sshow h
              return (acc, True)

    enforceUnique rks rk
      | S.member rk rks =
        throwM $ MempoolFillFailure $ "Duplicate transaction: " <> sshow rk
      | otherwise = return $ S.insert rk rks

    pHeight = _blockHeight $ _parentHeader newBlockParent
    pHash = _blockHash $ _parentHeader newBlockParent

    updateMempool = liftIO $ do
          mpaProcessFork mpAccess $ _parentHeader newBlockParent
          mpaSetLastHeader mpAccess $ _parentHeader newBlockParent