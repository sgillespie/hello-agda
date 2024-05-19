module HelloWorld where

open import Hello using (Greeting; hello)

open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# COMPILE GHC putStrLn = putStrLn . T.unpack #-}

greet' : Greeting → String
greet' hello = "Hello, World!"

main : IO ⊤
main = putStrLn (greet' hello)
