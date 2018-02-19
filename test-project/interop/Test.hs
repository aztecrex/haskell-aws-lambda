{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Test where

import Foreign.C (CString, newCString)
import Data.Aeson.Types (Object, emptyObject)
import Data.Aeson (ToJSON, FromJSON)
import Data.HashMap.Strict (insert)
import GHC.Generics
import Data.Text

import Cloud.Compute.AWS.Lambda (interop, toSerial, LambdaT, argument, runLambdaT, nogood)


data MathProblem = MathAdd {x :: Int, y :: Int } | MathMultiply { x :: Int, y :: Int} | MathZoo { animal :: Text }
    deriving (Show, Generic)
data MathAnswer = MathAnswer { answer :: Int }
    deriving (Show, Generic)
data MathError = MathError { description :: Text }
    deriving (Show, Generic)

instance ToJSON MathAnswer where
instance ToJSON MathError where
instance FromJSON MathProblem where

data ParseError = ParseError
    deriving (Show, Generic)

instance ToJSON ParseError

barm :: LambdaT MathProblem MathError IO MathAnswer
barm = do
    problem <- argument
    case problem of
        MathAdd x y -> pure $ MathAnswer (x + y)
        MathMultiply x y -> pure $ MathAnswer (x * y)
        MathZoo _ -> nogood $ MathError "there is no math at the zoo"

barf :: MathProblem -> IO (Either MathError MathAnswer)
barf = runLambdaT barm

foreign export ccall bar :: CString -> IO CString
bar :: CString -> IO CString
bar = interop $ toSerial ParseError barf

