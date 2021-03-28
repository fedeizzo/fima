{-# LANGUAGE OverloadedStrings #-}

module Data.Transaction.Operations where

import qualified Data.ByteString as B
import Data.Sequence (Seq)
import Data.Serialize (decode, encode)
import Data.Text (Text)
import Data.Time.Calendar
import Data.Transaction.Type
import Lens.Micro.Extras (view)

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
evalTransactions ts = foldl (\acc x -> acc + view amount x) 0 ts

filterTransactionType :: TransactionType -> [Transaction] -> [Transaction]
filterTransactionType ty ts = filter (\x -> view transactionType x == ty) ts

filterDate :: Day -> Day -> [Transaction] -> [Transaction]
filterDate start end ts = filter (\x -> start <= view date x && end >= view date x) ts

saveTransactions :: String -> Seq Transaction -> IO ()
saveTransactions path ts = do
  B.writeFile path $ encode ts

loadTransactions :: String -> IO (Either String (Seq Transaction))
loadTransactions path = do
  ts <- B.readFile path
  return $ (decode ts :: Either String (Seq Transaction))
