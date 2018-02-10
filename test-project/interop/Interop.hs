module Interop where

import System.IO
import Foreign.C


foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar v' = do
    v <- peekCString v'
    let ret = "Caller said: {" ++ v ++ "}"
    newCString ret

