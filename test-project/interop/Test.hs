{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Test where

import Foreign.C (CString, newCString)
import Data.Aeson (ToJSON, FromJSON)
import GHC.Generics (Generic)
import Control.Concurrent (threadDelay)
import Control.Monad.IO.Class (liftIO)
import Data.Default (Default (..))
import Data.Time.Clock (getCurrentTime)
import Data.Text (Text, pack)

import Cloud.Compute(runComputeT, ComputeT, MonadCompute (..))
import Cloud.Compute.Ephemeral (
    OperationContext, TimedOperationContext,
    MonadOperation (..), MonadTimedOperation(..),
    MonadClock (..), remainingTime)
import Cloud.AWS.Lambda (interop, toSerial, LambdaContext)


data MathProblem = MathAdd {x :: Int, y :: Int } | MathMultiply { x :: Int, y :: Int} | MathZoo { animal :: Text }
    deriving (Show, Generic)
data MathAnswer = MathAnswer {
    answer :: Int,
    opname :: Text,
    opversion :: Text,
    opinvocation :: Text,
    opdeadline :: Text }
    deriving (Show, Generic)
data MathError = MathError { description :: Text }
    deriving (Show, Generic)

instance Default MathAnswer where
    def = MathAnswer 0 "" "" "" ""

instance ToJSON MathAnswer where
instance ToJSON MathError where
instance FromJSON MathProblem where

instance MonadClock IO where
    currentTime = getCurrentTime

data ParseError = ParseError { description :: Text}
    deriving (Show, Generic)

instance ToJSON ParseError

barm :: (OperationContext ctx, TimedOperationContext ctx) => ComputeT ctx MathProblem MathError IO MathAnswer
barm = do
    liftIO $ threadDelay 1000000
    problem <- event
    case problem of
        MathAdd x y -> MathAnswer (x + y) <$> name <*> version <*> invocation <*> (text <$> remainingTime)
        MathMultiply x y -> MathAnswer (x * y) <$> name <*> version <*> invocation <*> (text <$> remainingTime)
        MathZoo _ -> do
            abort $ MathError "there is no math at the zoo"
            pure def
    where
        text = pack . show

barf :: LambdaContext -> MathProblem -> IO (Either MathError MathAnswer)
barf = runComputeT barm

foreign export ccall bar :: CString -> CString -> IO CString
bar :: CString -> CString -> IO CString
bar = interop $ toSerial (ParseError "Unrecognized input") barf
