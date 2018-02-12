module Interop.AWSLambda(makeLambda, runLambdaT, event) where

import Control.Monad.Trans.Class (MonadTrans, lift)
import Foreign.C (CString, newCString)
import Foreign.Marshal.Alloc(free)
import Data.Aeson (encode, decodeStrict, FromJSON, ToJSON, Object)
import Data.Aeson.Types (emptyObject)
import Data.ByteString (packCString, useAsCString, ByteString)
import Data.ByteString.Lazy (toStrict)
import Data.ByteString.Builder (toLazyByteString)
import Data.IORef (IORef, newIORef, atomicModifyIORef')
import Control.Applicative (Applicative, liftA2)

defaultObject :: ByteString
defaultObject = encodeStrict emptyObject

{-
This just holds a reference to the last-returned value. Otherwise it
might disappear before the caller can use it. An AWS Lambda instance
is invoked serially so this is safe.

Might be better to require the caller to allocate the memory.
-}
returned :: IO (IORef CString)
returned = newCString "{}" >>= newIORef

replace :: CString -> IO CString
replace v = do
    ref <- returned
    prev <- atomicModifyIORef' ref (\x -> (v, x))
    free prev
    pure v

clear :: IO CString
clear = newCString "{}" >>= replace

unpackCString :: ByteString -> IO CString
unpackCString bytes = useAsCString bytes replace

encodeStrict :: ToJSON a => a -> ByteString
encodeStrict = toStrict . encode

makeLambda :: (FromJSON a, ToJSON b) => (a -> IO b) -> CString -> IO CString
makeLambda f event = do
    bytes <- packCString event
    let maybeA = decodeStrict bytes
    let maybeB = f <$> maybeA
    case maybeB of
        Just iob -> do
          b <- iob
          unpackCString $ encodeStrict b
        _ -> clear


newtype LambdaT p m a = LambdaT { runLambdaT :: p -> m a }

instance (Functor m) => Functor (LambdaT p m) where
    fmap f (LambdaT fa) = LambdaT $ (fmap .fmap) f fa

instance (Applicative m) => Applicative (LambdaT p m) where
    pure = liftLambdaT . pure
    LambdaT mf <*> LambdaT mx = LambdaT $ liftA2 (<*>) mf mx

chl :: (Monad m) => LambdaT p m a -> (a -> LambdaT p m b) -> LambdaT p m b
chl (LambdaT rf) f = LambdaT $ \p -> do
    a <- rf p
    runLambdaT (f a) p

instance (Monad m) => Monad (LambdaT p m) where
    ma >>= f = chl ma f


liftLambdaT :: (Functor m) => m a -> LambdaT p m a
liftLambdaT mx = LambdaT $ const mx

instance MonadTrans (LambdaT p) where
    lift = liftLambdaT

event :: (Monad m) => LambdaT p m p
event = LambdaT pure


