module Interop where

import System.IO
import Foreign.C
-- import Data.Aeson
import Data.ByteString
import Data.Text (Text)
import Data.Text.Encoding
import Data.IORef

returned :: IO (IORef CString)
returned = do
    init <- newCString ""
    newIORef init

replace :: CString -> IO CString
replace v = do
    ref <- returned
    writeIORef ref v
    pure v

decode :: CString -> IO Text
decode raw = decodeUtf8 <$> packCString raw

encode :: Text -> IO CString
encode cooked = useAsCString (encodeUtf8 cooked) replace

foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar v' = do
    v <- decode v'
    encode v
