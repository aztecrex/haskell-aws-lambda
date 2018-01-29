module Interop where


foreign export ccall bar :: a -> IO ()
bar x = putStrLn "Hello from Haskell SO"

