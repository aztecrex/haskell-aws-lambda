module Interop where

import System.IO
import Foreign.C

foreign export ccall bar :: CString -> IO ()
bar x = do
    putStrLn "Hello from Haskell SO"
    hFlush stdout
    return ()


