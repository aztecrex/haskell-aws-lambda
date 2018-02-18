module Interop.AWS.Lambda where

import Control.Monad.Trans.Class (MonadTrans, lift)
import Data.Text (Text)

data LambdaContext = LambdaContext { name :: Text }

newtype LambdaT ev err m a = LambdaT { runLambdaT :: (LambdaContext, Maybe ev) -> m (Either err a) }
    deriving (Functor)

liftLambdaT :: (Monad m) => m a -> LambdaT ev err m a
liftLambdaT mx = LambdaT $ const $ do
    x <- mx
    pure $ Right x

-- instance (Applicative m) => Applicative (LambdaT p m) where
--     pure = liftLambdaT . pure
--     LambdaT mf <*> LambdaT mx = LambdaT $ liftA2 (<*>) mf mx

-- instance (Monad m) => Monad (LambdaT p m) where
--     (LambdaT rf) >>= f = LambdaT $ \p -> do
--         a <- rf p
--         runLambdaT (f a) p

-- instance MonadTrans (LambdaT p) where
--     lift = liftLambdaT

-- event :: (Monad m) => LambdaT ev err m ev
-- event = LambdaT (pure . snd)

-- context :: (Monad m) => LambdaT ev err m LambdaContext
-- context = LambdaT (pure . fst)


