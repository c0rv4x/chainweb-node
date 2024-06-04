{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Chainweb.Mempool.Consensus
( chainwebTxsFromPd
, MempoolConsensus(..)
, mkMempoolConsensus
, processFork
, processFork'
, processForkCheckTTL
, ReintroducedTxsLog (..)
) where

------------------------------------------------------------------------------
import Control.DeepSeq
import Control.Exception
import Control.Monad

import Data.Aeson
import Data.Either
import Data.Foldable (toList)
import Data.Hashable
import Data.HashSet (HashSet)
import qualified Data.HashSet as HS
import Data.IORef
import Data.Vector (Vector)
import qualified Data.Vector as V

import GHC.Generics

import System.LogLevel

------------------------------------------------------------------------------
import Chainweb.BlockHeader
import Chainweb.BlockHeaderDB
import Chainweb.Mempool.InMem
import Chainweb.Mempool.Mempool
import Chainweb.Payload
import Chainweb.Payload.PayloadStore
import Chainweb.Time
import Chainweb.Transaction
import Chainweb.TreeDB
import Chainweb.Utils
import Chainweb.Version
import Chainweb.Version.Guards

import Data.LogMessage (JsonLog(..), LogFunction)

------------------------------------------------------------------------------
data MempoolConsensus = MempoolConsensus
    { mpcMempool :: !(MempoolBackend Pact4Transaction)
    , mpcLastNewBlockParent :: !(IORef (Maybe BlockHeader))
    , mpcProcessFork
        :: LogFunction -> BlockHeader -> IO (Vector Pact4Transaction, Vector Pact4Transaction)
    }

data ReintroducedTxsLog = ReintroducedTxsLog
    { oldForkHeader :: ObjectEncoded BlockHeader
    , newForkHeader :: ObjectEncoded BlockHeader
    , numReintroduced :: Int }
    deriving (Eq, Show, Generic)
    deriving anyclass (ToJSON, NFData)

newtype MempoolException = MempoolConsensusException String

instance Show MempoolException where
    show (MempoolConsensusException s) =
        "Error with mempool's consensus processing: " ++ s

instance Exception MempoolException

------------------------------------------------------------------------------
mkMempoolConsensus
    :: CanReadablePayloadCas tbl
    => MempoolBackend Pact4Transaction
    -> BlockHeaderDb
    -> Maybe (PayloadDb tbl)
    -> IO MempoolConsensus
mkMempoolConsensus mempool blockHeaderDb payloadStore = do
    lastParentRef <- newIORef Nothing :: IO (IORef (Maybe BlockHeader))

    return MempoolConsensus
        { mpcMempool = mempool
        , mpcLastNewBlockParent = lastParentRef
        , mpcProcessFork = processFork blockHeaderDb payloadStore lastParentRef
        }


------------------------------------------------------------------------------
processFork
    :: CanReadablePayloadCas tbl
    => BlockHeaderDb
    -> Maybe (PayloadDb tbl)
    -> IORef (Maybe BlockHeader)
    -> LogFunction
    -> BlockHeader
    -> IO (Vector Pact4Transaction, Vector Pact4Transaction)
processFork blockHeaderDb payloadStore lastHeaderRef logFun newHeader = do
    now <- getCurrentTimeIntegral
    lastHeader <- readIORef lastHeaderRef
    let v = _chainwebVersion blockHeaderDb
        cid = _chainId blockHeaderDb
        height = _blockHeight newHeader
    (a, b) <- processFork' logFun blockHeaderDb newHeader lastHeader
                           (payloadLookup payloadStore)
                           (processForkCheckTTL (pactParserVersion v cid height) now)
    return (V.map unHashable a, V.map unHashable b)


------------------------------------------------------------------------------
processForkCheckTTL
    :: PactParserVersion
    -> Time Micros
    -> HashableTrans PayloadWithText -> Bool
processForkCheckTTL ppv now (HashableTrans t) =
    either (const False) (const True) $
    txTTLCheck (pact4TransactionConfig ppv) now t


------------------------------------------------------------------------------
-- called directly from some unit tests...
processFork'
  :: (Eq x, Hashable x)
    => LogFunction
    -> BlockHeaderDb
    -> BlockHeader
    -> Maybe BlockHeader
    -> (BlockHeader -> IO (HashSet x))
    -> (x -> Bool)
    -> IO (V.Vector x, V.Vector x)
processFork' logFun db newHeader lastHeaderM plLookup flt =
    maybe (return (V.empty, V.empty)) go lastHeaderM
  where
    go lastHeader = do
        (_, oldBlocks, newBlocks) <- collectForkBlocks db lastHeader newHeader
        oldTrans <- foldM toSet mempty oldBlocks
        newTrans <- foldM toSet mempty newBlocks

        -- before re-introducing the transactions from the losing fork (aka
        -- oldBlocks), filter out any transactions that have been included in
        -- the winning fork (aka newBlocks):
        let !results = V.fromList $ filter flt
                                  $ HS.toList
                                  $ oldTrans `HS.difference` newTrans
        let !deletes = V.fromList $ HS.toList newTrans

        unless (V.null results) $ do
            -- create data for the dashboard showing number or reintroduced
            -- transactions:
            let !reIntro = ReintroducedTxsLog
                               { oldForkHeader = ObjectEncoded lastHeader
                               , newForkHeader = ObjectEncoded newHeader
                               , numReintroduced = V.length results
                               }
            logFun @(JsonLog ReintroducedTxsLog) Info $ JsonLog reIntro
        return (results, deletes)
      where
        toSet !trans !header = HS.union trans <$!> plLookup header


------------------------------------------------------------------------------
payloadLookup
    :: CanReadablePayloadCas tbl
    => Maybe (PayloadDb tbl)
    -> BlockHeader
    -> IO (HashSet (HashableTrans PayloadWithText))
payloadLookup payloadStore bh =
    case payloadStore of
        Nothing -> return mempty
        Just s -> do
            pd <- lookupPayloadDataWithHeight s (Just (_blockHeight bh)) (_blockPayloadHash bh)
            pd' <- maybe (throwIO $ PayloadNotFoundException (_blockPayloadHash bh)) pure pd
            chainwebTxsFromPd (pactParserVersion (_chainwebVersion bh) (_chainId bh) (_blockHeight bh)) pd'

------------------------------------------------------------------------------
chainwebTxsFromPd
    :: PactParserVersion
    -> PayloadData
    -> IO (HashSet (HashableTrans PayloadWithText))
chainwebTxsFromPd ppv pd = do
    let transSeq = _payloadDataTransactions pd
    let bytes = _transactionBytes <$> transSeq
    let eithers = toCWTransaction <$> bytes
    -- Note: if any transactions fail to convert, the final validation hash will fail to match
    -- the one computed during newBlock
    let theRights  =  rights $ toList eithers
    return $! HS.fromList $ HashableTrans <$!> theRights
  where
    toCWTransaction = codecDecode (pact4PayloadCodec ppv)
