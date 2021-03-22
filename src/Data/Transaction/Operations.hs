{-# LANGUAGE OverloadedStrings #-}

module Data.Transaction.Operations where

import Data.Text (Text)
import Data.Transaction.Type
import Data.Time.Calendar

mkTransaction ::
  Double ->
  Integer ->
  Int ->
  Int ->
  TransactionType ->
  Text ->
  Either TransactionError Transaction
mkTransaction am year month day ty de =
  case dt of
    (Just d) -> Right $ Transaction am d ty de
    Nothing -> Left TransactionInitialization
  where
    dt = fromGregorianValid year month day

evalTransactions :: [Transaction] -> Double
evalTransactions ts = foldl (\acc x -> acc + amount x) 0 ts

filterTransactionType :: TransactionType -> [Transaction] -> [Transaction]
filterTransactionType ty ts = filter (\x -> transactionType x == ty) ts

filterDate :: Day -> Day -> [Transaction] -> [Transaction]
filterDate start end ts = filter (\x -> start <= date x && end >= date x) ts
