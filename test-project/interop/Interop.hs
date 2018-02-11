module Interop where

import Foreign.C
import Data.HashMap.Strict(empty)
import Data.Aeson (encode, decode, Object, FromJSON, ToJSON)
import Data.ByteString (packCString, useAsCString)
import Data.ByteString.Lazy(toStrict, fromStrict)
import Data.IORef

{-
This just holds a reference to the last-returned value. Otherwise it
might disappear before the caller can use it. An AWS Lambda instance
is invoked serially so this is safe.

Might be better to require the caller to allocate the memory.
-}
returned :: IO (IORef CString)
returned = do
    init <- newCString ""
    newIORef init

replace :: CString -> IO CString
replace v = do
    ref <- returned
    writeIORef ref v
    pure v

rawToJson :: FromJSON a => CString -> IO (Maybe a)
rawToJson raw = do
    bytes <- packCString raw
    pure $ decode (fromStrict bytes)

jsonToRaw :: ToJSON a => a -> IO CString
jsonToRaw v = do
    let bytes = encode v
    useAsCString (toStrict bytes) replace

foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar event = do
    maybeObj <- rawToJson event :: IO (Maybe Object)
    let r = maybe empty id maybeObj
    jsonToRaw r
