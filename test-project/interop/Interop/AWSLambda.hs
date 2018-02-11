module Interop.AWSLambda(makeLambda) where

import Foreign.C (CString, newCString)
import Foreign.Marshal.Alloc(free)
import Data.Aeson (encode, decodeStrict, FromJSON, ToJSON)
import Data.ByteString (packCString, useAsCString, ByteString)
import Data.ByteString.Lazy(toStrict)
import Data.IORef (IORef, newIORef, atomicModifyIORef')

{-
This just holds a reference to the last-returned value. Otherwise it
might disappear before the caller can use it. An AWS Lambda instance
is invoked serially so this is safe.

Might be better to require the caller to allocate the memory.
-}
returned :: IO (IORef CString)
returned = newCString "{}" >>= newIORef

replace :: CString -> IO CString
replace v = do
    ref <- returned
    prev <- atomicModifyIORef' ref (\x -> (v, x))
    free prev
    pure v

clear :: IO CString
clear = newCString "{}" >>= replace

unpackCString :: ByteString -> IO CString
unpackCString bytes = useAsCString bytes replace

encodeStrict :: ToJSON a => a -> ByteString
encodeStrict = toStrict . encode

makeLambda :: (FromJSON a, ToJSON b) => (a -> IO b) -> CString -> IO CString
makeLambda f event = do
    bytes <- packCString event
    let maybeA = decodeStrict bytes
    let maybeB = f <$> maybeA
    case maybeB of
        Just iob -> do
          b <- iob
          unpackCString $ encodeStrict b
        _ -> clear
