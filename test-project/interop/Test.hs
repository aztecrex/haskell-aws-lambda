{-# LANGUAGE OverloadedStrings #-}
module Test where

import Foreign.C (CString, newCString)
import Data.Aeson.Types (Object, emptyObject)
import Data.HashMap.Strict (insert)

import Cloud.Compute.AWS.Lambda (interop, toSerial, LambdaT, argument, runLambdaT)

-- transform :: (Monad m) => Object -> m (Either Object Object)
-- transform = pure . Right


barm :: LambdaT Object Object IO Object
barm = do
    input <- argument
    pure $ insert "added" "yo yo yo" input


barf :: Object -> IO (Either Object Object)
barf = runLambdaT barm

foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar = interop $ toSerial emptyObject barf

