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

add :: (Num a, Applicative m) => a -> a -> m a
add x y = pure $ x + y

multiply :: (Num a, Applicative m) => a ->  a ->  m a
multiply x y = pure $ x * y

zoo :: (Monad m, MonadCompute ctx evt MathError m) => Text -> m a
zoo a = abort $ MathError $ "A " <> a <> " cannot perform math at the zoo."


solve :: (Monad m, MonadCompute ctx MathProblem MathError m) => m MathAnswer
solve = do
    problem <- event
    MathAnswer <$> case problem of
        MathAdd x y -> add x y
        MathMultiply x y -> multiply x y
        MathZoo x -> zoo x











