module Test where

import Foreign.C (CString, newCString)
import Data.Aeson (Object)

import Interop.AWSLambda(makeLambda)

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



