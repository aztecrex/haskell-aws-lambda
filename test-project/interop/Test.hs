{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Test where

import Foreign.C (CString, newCString)
import Data.Aeson (ToJSON, FromJSON)
import GHC.Generics (Generic)
import Data.Default (Default (..))
import Data.Text (Text)

import Cloud.Compute(runComputeT, ComputeT, MonadCompute (..))
import Cloud.Compute.Ephemeral (MonadOperation (..))
import Cloud.AWS.Lambda (interop, toSerial, LambdaContext)


data MathProblem = MathAdd {x :: Int, y :: Int } | MathMultiply { x :: Int, y :: Int} | MathZoo { animal :: Text }
    deriving (Show, Generic)
data MathAnswer = MathAnswer { answer :: Int, opname :: Text, opversion :: Text, opinvocation :: Text }
    deriving (Show, Generic)
data MathError = MathError { description :: Text }
    deriving (Show, Generic)

instance Default MathAnswer where
    def = MathAnswer 0 "" "" ""

instance ToJSON MathAnswer where
instance ToJSON MathError where
instance FromJSON MathProblem where

data ParseError = ParseError { description :: Text}
    deriving (Show, Generic)

instance ToJSON ParseError

barm :: ComputeT LambdaContext MathProblem MathError IO MathAnswer
barm = do
    problem <- event
    case problem of
        MathAdd x y -> MathAnswer (x + y) <$> name <*> version <*> invocation
        MathMultiply x y -> MathAnswer (x * y) <$> name <*> version <*> invocation
        MathZoo _ -> do
            abort $ MathError "there is no math at the zoo"
            pure def



barf :: LambdaContext -> MathProblem -> IO (Either MathError MathAnswer)
barf = runComputeT barm

foreign export ccall bar :: CString -> CString -> IO CString
bar :: CString -> CString -> IO CString
bar = interop $ toSerial (ParseError "Unrecognized input") barf

