{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Test where

import Foreign.C (CString, newCString)
import Data.Aeson (ToJSON, FromJSON)
import GHC.Generics (Generic)
import Control.Concurrent (threadDelay)
import Control.Monad.IO.Class (liftIO)
import Data.Time.Clock (getCurrentTime)
import Data.Text (Text, pack)

import Cloud.Compute(runComputeT, ComputeT, MonadCompute (..))
import Cloud.Compute.Ephemeral (
    OperationContext, TimedOperationContext,
    MonadOperation (..), MonadTimedOperation(..),
    remainingTime)
import Cloud.AWS.Lambda (interop, toSerial, LambdaContext)
import Math (solve, MathProblem, MathError, MathAnswer)

data ParseError = ParseError { description :: Text}
    deriving (Show, Generic)

instance ToJSON ParseError

barm :: (OperationContext ctx, TimedOperationContext ctx) => ComputeT ctx MathProblem MathError IO MathAnswer
barm = solve

barf :: LambdaContext -> MathProblem -> IO (Either MathError MathAnswer)
barf = runComputeT barm

foreign export ccall bar :: CString -> CString -> IO CString
bar :: CString -> CString -> IO CString
bar = interop $ toSerial (ParseError "Unrecognized input") barf
