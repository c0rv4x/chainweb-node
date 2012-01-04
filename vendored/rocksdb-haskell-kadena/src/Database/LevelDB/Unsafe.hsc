{-# LANGUAGE CPP, ForeignFunctionInterface #-}

module Database.LevelDB.Unsafe where

import Foreign
import Foreign.C.Types
import Foreign.C.String

import Database.LevelDB.Base

#include <leveldb/c.h>

foreign import ccall unsafe "leveldb/c.h leveldb_open"
  c_unsafe_leveldb_open :: OptionsPtr -> DBName -> ErrPtr -> IO LevelDBPtr

foreign import ccall unsafe "leveldb/c.h leveldb_close"
  c_unsafe_leveldb_close :: LevelDBPtr -> IO ()


foreign import ccall unsafe "leveldb/c.h leveldb_put"
  c_unsafe_leveldb_put :: LevelDBPtr
                -> WriteOptionsPtr
                -> Key -> CSize
                -> Val -> CSize
                -> ErrPtr
                -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_delete"
  c_unsafe_leveldb_delete :: LevelDBPtr
                   -> WriteOptionsPtr
                   -> Key -> CSize
                   -> ErrPtr
                   -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_write"
  c_unsafe_leveldb_write :: LevelDBPtr
                  -> WriteOptionsPtr
                  -> WriteBatchPtr
                  -> ErrPtr
                  -> IO ()

-- | Returns NULL if not found. A malloc()ed array otherwise. Stores the length
-- of the array in *vallen.
foreign import ccall unsafe "leveldb/c.h leveldb_get"
  c_unsafe_leveldb_get :: LevelDBPtr
                -> ReadOptionsPtr
                -> Key -> CSize
                -> Ptr CSize        -- ^ value length
                -> ErrPtr
                -> IO CString

foreign import ccall unsafe "leveldb/c.h leveldb_create_snapshot"
  c_unsafe_leveldb_create_snapshot :: LevelDBPtr -> IO SnapshotPtr

foreign import ccall unsafe "leveldb/c.h leveldb_release_snapshot"
  c_unsafe_leveldb_release_snapshot :: LevelDBPtr -> SnapshotPtr -> IO ()

-- | Returns NULL if property name is unknown. Else returns a pointer to a
-- malloc()-ed null-terminated value.
foreign import ccall unsafe "leveldb/c.h leveldb_property_value"
  c_unsafe_leveldb_property_value :: LevelDBPtr -> CString -> IO (Ptr CString)

foreign import ccall unsafe "leveldb/c.h leveldb_approximate_sizes"
  c_unsafe_leveldb_approximate_sizes :: LevelDBPtr
                              -> CInt                     -- ^ num ranges
                              -> Ptr CString -> Ptr CSize -- ^ range start keys (array)
                              -> Ptr CString -> Ptr CSize -- ^ range limit keys (array)
                              -> Ptr Word64               -- ^ array of approx. sizes of ranges
                              -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_destroy_db"
  c_unsafe_leveldb_destroy_db :: OptionsPtr -> DBName -> ErrPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_repair_db"
  c_unsafe_leveldb_repair_db :: OptionsPtr -> DBName -> ErrPtr -> IO ()

-- ^ Iterator

foreign import ccall unsafe "leveldb/c.h leveldb_create_iterator"
  c_unsafe_leveldb_create_iterator :: LevelDBPtr -> ReadOptionsPtr -> IO IteratorPtr

foreign import ccall unsafe "leveldb/c.h leveldb_iter_destroy"
  c_unsafe_leveldb_iter_destroy :: IteratorPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_iter_valid"
  c_unsafe_leveldb_iter_valid :: IteratorPtr -> IO CUChar

foreign import ccall unsafe "leveldb/c.h leveldb_iter_seek_to_first"
  c_unsafe_leveldb_iter_seek_to_first :: IteratorPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_iter_seek_to_last"
  c_unsafe_leveldb_iter_seek_to_last :: IteratorPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_iter_seek"
  c_unsafe_leveldb_iter_seek :: IteratorPtr -> Key -> CSize -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_iter_next"
  c_unsafe_leveldb_iter_next :: IteratorPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_iter_prev"
  c_unsafe_leveldb_iter_prev :: IteratorPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_iter_key"
  c_unsafe_leveldb_iter_key :: IteratorPtr -> Ptr CSize -> IO Key

foreign import ccall unsafe "leveldb/c.h leveldb_iter_value"
  c_unsafe_leveldb_iter_value :: IteratorPtr -> Ptr CSize -> IO Val

foreign import ccall unsafe "leveldb/c.h leveldb_iter_get_error"
  c_unsafe_leveldb_iter_get_error :: IteratorPtr -> ErrPtr -> IO ()

-- ^ Write batch

foreign import ccall unsafe "leveldb/c.h leveldb_writebatch_create"
  c_unsafe_leveldb_writebatch_create :: IO WriteBatchPtr

foreign import ccall unsafe "leveldb/c.h leveldb_writebatch_destroy"
  c_unsafe_leveldb_writebatch_destroy :: WriteBatchPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_writebatch_clear"
  c_unsafe_leveldb_writebatch_clear :: WriteBatchPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_writebatch_put"
  c_unsafe_leveldb_writebatch_put :: WriteBatchPtr
                           -> Key -> CSize
                           -> Val -> CSize
                           -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_writebatch_delete"
  c_unsafe_leveldb_writebatch_delete :: WriteBatchPtr -> Key -> CSize -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_writebatch_iterate"
  c_unsafe_leveldb_writebatch_iterate :: WriteBatchPtr
                               -> Ptr ()                            -- ^ state
                               -> FunPtr (Ptr () -> Key -> CSize -> Val -> CSize) -- ^ put
                               -> FunPtr (Ptr () -> Key -> CSize)     -- ^ delete
                               -> IO ()

-- ^ Options

foreign import ccall unsafe "leveldb/c.h leveldb_options_create"
  c_unsafe_leveldb_options_create :: IO OptionsPtr

foreign import ccall unsafe "leveldb/c.h leveldb_options_destroy"
  c_unsafe_leveldb_options_destroy :: OptionsPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_comparator"
  c_unsafe_leveldb_options_set_comparator :: OptionsPtr -> ComparatorPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_create_if_missing"
  c_unsafe_leveldb_options_set_create_if_missing :: OptionsPtr -> CUChar -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_error_if_exists"
  c_unsafe_leveldb_options_set_error_if_exists :: OptionsPtr -> CUChar -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_paranoid_checks"
  c_unsafe_leveldb_options_set_paranoid_checks :: OptionsPtr -> CUChar -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_env"
  c_unsafe_leveldb_options_set_env :: OptionsPtr -> EnvPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_info_log"
  c_unsafe_leveldb_options_set_info_log :: OptionsPtr -> LoggerPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_write_buffer_size"
  c_unsafe_leveldb_options_set_write_buffer_size :: OptionsPtr -> CSize -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_max_open_files"
  c_unsafe_leveldb_options_set_max_open_files :: OptionsPtr -> CInt -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_block_size"
  c_unsafe_leveldb_options_set_block_size :: OptionsPtr -> CSize -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_block_restart_interval"
  c_unsafe_leveldb_options_set_block_restart_interval :: OptionsPtr -> CInt -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_options_set_compression"
  c_unsafe_leveldb_options_set_compression :: OptionsPtr -> CompressionOpt -> IO ()

-- ^ Read options

foreign import ccall unsafe "leveldb/c.h leveldb_readoptions_create"
  c_unsafe_leveldb_readoptions_create :: IO ReadOptionsPtr

foreign import ccall unsafe "leveldb/c.h leveldb_readoptions_destroy"
  c_unsafe_leveldb_readoptions_destroy :: ReadOptionsPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_readoptions_set_verify_checksums"
  c_unsafe_leveldb_readoptions_set_verify_checksums :: ReadOptionsPtr -> CUChar -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_readoptions_set_fill_cache"
  c_unsafe_leveldb_readoptions_set_fill_cache :: ReadOptionsPtr -> CUChar -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_readoptions_set_snapshot"
  c_unsafe_leveldb_readoptions_set_snapshot :: ReadOptionsPtr -> SnapshotPtr -> IO ()

-- ^ Write options

foreign import ccall unsafe "leveldb/c.h leveldb_writeoptions_create"
  c_unsafe_leveldb_writeoptions_create :: IO WriteOptionsPtr

foreign import ccall unsafe "leveldb/c.h leveldb_writeoptions_destroy"
  c_unsafe_leveldb_writeoptions_destroy :: WriteOptionsPtr -> IO ()

foreign import ccall unsafe "leveldb/c.h leveldb_writeoptions_set_sync"
  c_unsafe_leveldb_writeoptions_set_sync :: WriteOptionsPtr -> CUChar -> IO ()

-- ^ Cache

foreign import ccall unsafe "leveldb/c.h leveldb_cache_create_lru"
  c_unsafe_leveldb_cache_create_lru :: CSize -> IO CachePtr

foreign import ccall unsafe "leveldb/c.h leveldb_cache_destroy"
  c_unsafe_leveldb_cache_destroy :: CachePtr -> IO ()

-- ^ Env

foreign import ccall unsafe "leveldb/c.h leveldb_create_default_env"
  c_unsafe_leveldb_create_default_env :: IO EnvPtr

foreign import ccall unsafe "leveldb/c.h leveldb_env_destroy"
  c_unsafe_leveldb_env_destroy :: EnvPtr -> IO ()
