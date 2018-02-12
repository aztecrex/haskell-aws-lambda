{-# LANGUAGE TemplateHaskell #-}
module Interop.AWSLambda.TH where


import Foreign.C (CString)
import Control.Monad
import Language.Haskell.TH (Name, Dec, Q)

import Interop.AWSLambda.Internal




-- interopT :: TypeQ
-- interopT = [t| CString -> IO CString|]





-- curryN :: Int -> Q Exp
-- curryN n = do
--   f  <- newName "f"
--   xs <- replicateM n (newName "x")
--   let args = map VarP (f:xs)
--       ntup = TupE (map VarE xs)
--   return $ LamE args (AppE (VarE f) ntup)



-- Prelude Language.Haskell.TH Language.Haskell.TH.Syntax> :t runQ
-- runQ :: Quasi m => Q a -> m a
-- Prelude Language.Haskell.TH Language.Haskell.TH.Syntax> :t runQ [t| Bool -> IO Bool|]
-- runQ [t| Bool -> IO Bool|] :: Quasi m => m Type
-- Prelude Language.Haskell.TH Language.Haskell.TH.Syntax> :t \t -> ForeignD (ExportF CCall "" (mkName "foo") t)
-- \t -> ForeignD (ExportF CCall "" (mkName "foo") t) :: Type -> Dec
-- Prelude Language.Haskell.TH Language.Haskell.TH.Syntax> runQ [t| Bool -> IO Bool|] >>= \t -> ForeignD (ExportF CCall "" (mkName "foo") t)

-- <interactive>:63:38:
--     Couldn't match expected type ‘m b’ with actual type ‘Dec’
--     Relevant bindings include it :: m b (bound at <interactive>:63:1)
--     In the expression: ForeignD (ExportF CCall "" (mkName "foo") t)
--     In the second argument of ‘(>>=)’, namely
--       ‘\ t -> ForeignD (ExportF CCall "" (mkName "foo") t)’
-- Prelude Language.Haskell.TH Language.Haskell.TH.Syntax> runQ [t| Bool -> IO Bool|] >>= \t -> pure $ ForeignD (ExportF CCall "" (mkName "foo") t)
-- ForeignD (ExportF CCall "" foo (AppT (AppT ArrowT (ConT GHC.Types.Bool)) (AppT (ConT GHC.Types.IO) (ConT GHC.Types.Bool))))
-- Prelude Language.Haskell.TH Language.Haskell.TH.Syntax> :t [t| Bool -> IO Bool|]
-- [t| Bool -> IO Bool|] :: TypeQ
-- Prelude Language.Haskell.TH Language.Haskell.TH.Syntax>
