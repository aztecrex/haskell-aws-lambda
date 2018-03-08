module Math (
    solve,
    MathProblem,
    MathAnswer,
    MathError
    ) where

import Cloud.Compute (MonadCompute (..))
import Data.Aeson (ToJSON, FromJSON)
import Data.Monoid ((<>))
import Data.Text (Text)
import GHC.Generics (Generic)

data MathProblem = MathAdd {x :: Int, y :: Int } | MathMultiply { x :: Int, y :: Int} | MathZoo { animal :: Text }
    deriving (Show, Generic)
instance FromJSON MathProblem

data MathAnswer = MathAnswer { answer :: Int }
    deriving (Show, Generic)
instance ToJSON MathAnswer

data MathError = MathError { description :: Text }
    deriving (Show, Generic)
instance ToJSON MathError


solve :: (Monad m, MonadCompute ctx MathProblem MathError m) => m MathAnswer
solve = do
    problem <- event
    case problem of
        MathAdd x y -> pure $ MathAnswer (x + y)
        MathMultiply x y -> pure $ MathAnswer (x * y)
        MathZoo x -> abort $ MathError ("a " <> x <> " is not capable of math")











