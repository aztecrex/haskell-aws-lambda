{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Test where

import Foreign.C (CString, newCString)
import Data.Aeson.Types (Object, emptyObject)
import Data.Aeson (ToJSON, FromJSON)
import Data.HashMap.Strict (insert)
import GHC.Generics
import Data.Text

import Cloud.Compute.AWS.Lambda (interop, toSerial, LambdaT, argument, runLambdaT)


data MathProblem = MathAdd {x :: Int, y :: Int } | MathMultiply { x :: Int, y :: Int} | MathZoo { animal :: Text }
    deriving (Show, Generic)
data MathAnswer = MathAnswer { answer :: Int }
    deriving (Show, Generic)
data MathError = MathError { description :: Text }
    deriving (Show, Generic)

instance ToJSON MathAnswer where
instance ToJSON MathError where
instance FromJSON MathProblem where
instance ToJSON MathProblem where

data ParseError = ParseError
    deriving (Show, Generic)

instance ToJSON ParseError

barm :: LambdaT Object Object IO MathProblem
barm = do
    pure $ MathAdd 101 993
    -- problem <- argument
    -- case problem of
    --     Add x y -> pure $ MathAnswer (x + y)
    --     Multiply x y -> pure $ MathAnswer (x * y)
    --     MathZoo _ -> pure $ MathError "there is no math at the zoo"
    -- pure $ insert "added" "yo yo yo" input


barf :: Object -> IO (Either Object MathProblem)
barf = runLambdaT barm

foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar = interop $ toSerial ParseError barf

