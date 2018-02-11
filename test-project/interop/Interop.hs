module Interop where

import Foreign.C
import Data.Aeson (encode, decodeStrict, Object, FromJSON, ToJSON)
import Data.ByteString (packCString, useAsCString, empty, ByteString)
import Data.ByteString.Lazy(toStrict)
import Data.IORef

{-
This just holds a reference to the last-returned value. Otherwise it
might disappear before the caller can use it. An AWS Lambda instance
is invoked serially so this is safe.

Might be better to require the caller to allocate the memory.
-}
returned :: IO (IORef CString)
returned = do
    init <- newCString "{}"
    newIORef init

replace :: CString -> IO CString
replace v = do
    ref <- returned
    writeIORef ref v
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

transform :: Object -> Object
transform = id

effectfulTransform :: Object -> IO Object
effectfulTransform = pure <$> transform

foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar = makeLambda effectfulTransform



-- foreign export ccall bar :: CString -> IO CString
-- bar :: CString -> IO CString
-- bar event = do
--     bytes <- packCString event
--     let maybeObj = decodeStrict bytes :: Maybe Object
--     let maybeR = encodeStrict <$> maybeObj
--     let r = maybe empty id maybeR
--     unpackCString r



