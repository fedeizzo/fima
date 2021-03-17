{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (forever)
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Data.Char (ord)
import Data.Either
import Data.List
import Data.Serialize (decode, encode)
import Date.Date
import Transaction.Transaction

saveTransactions :: String -> Transactions -> IO ()
saveTransactions path ts = do
  B.writeFile path $ encode ts

-- loadTransactions :: IO (Transactions)
-- loadTransactions path = do
--   ts <- B.readFile path
--   return $ Transactions (rights (decode ts :: Either String Transactions)

prova = Transactions $ rights [tranEx1, tranEx2, tranEx3]

helpMessage :: String
helpMessage =
  "Commands:\n \
  \\tnew: crate new transaction\n \
  \\tshow: show transactions in memory\n \
  \\tload: load transactions from file\n \
  \\tsave: save transactions to file"

main :: IO ()
main = do
  putStrLn helpMessage
  cmd <- getLine
  case cmd of
    "new" -> putStrLn "new"
