module Entry(
  main
) where

import Lexer
import Parser
import Monad
import Syntax
import Pretty
import Eval
import Verify
import Binary
import Hex
import Core (toCore)

import Control.Monad
import Control.Applicative

import Data.Word
import Data.Char
import Data.List hiding (group)
import Data.Serialize
import qualified Data.ByteString as BS

import System.Process

import Text.Show.Pretty
import Numeric (showHex)

parse :: String -> Either ParseError [Decl]
parse fs = runParseM prog (scan fs)

file :: FilePath -> IO (Either ParseError [Decl])
file fname = do
  contents <- readFile fname
  {-print $ scan contents-}
  return $ parse contents

main :: IO ()
main = do
  ast1 <- file "example1.wasm"
  {-ast2 <- file "example2.wasm"-}
  putStrLn $ ppShow ast1
  {-putStrLn $ ppShow ast2-}

  case ast1 of
    Left err -> return ()
    Right [mod] -> do
      let bs = encode (toCore mod)
      {-mapM_ print (ByteString.unpack bs)-}
      {-fd <- open "example1.bin"-}
      putStrLn $ simpleHex bs
      BS.writeFile "example1.bin" bs
      system "hexdump example1.bin"
      return ()

  putStrLn "Done"
  return ()
