module Test where

import Foreign.C (CString, newCString)
import Data.Aeson.Types (Object, emptyObject)

import Cloud.Compute.AWS.Lambda (interop, toSerial)

transform :: (Monad m) => Object -> m (Either Object Object)
transform = pure . Right


foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar = interop $ toSerial emptyObject transform


-- toSerial :: (FromJSON input, ToJSON output, ToJSON error, ToJSON invalid) => invalid -> (input -> IO (Either output error)) -> ByteString -> IO ByteString



-- foreign export ccall bar :: CString -> IO CString
-- bar :: CString -> IO CString
-- bar event = do
--     bytes <- packCString event
--     let maybeObj = decodeStrict bytes :: Maybe Object
--     let maybeR = encodeStrict <$> maybeObj
--     let r = maybe empty id maybeR
--     unpackCString r



