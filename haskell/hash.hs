-- output 2

module TestHash where

import GHC.Int
import Data.HashTable as HashTable
import Data.Maybe as Maybe

hash :: IO (HashTable Int32 Int32)
hash = new (==) id

main = do
  h <- hash
  insert h 1 2
  v <- HashTable.lookup h 1
  putStrLn $ show $ Maybe.fromJust v
