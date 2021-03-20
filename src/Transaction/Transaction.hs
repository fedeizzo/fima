{-# LANGUAGE OverloadedStrings #-}

module Transaction.Transaction where

import Data.Either (fromRight, isRight)
import Data.Int
import Data.Serialize
import Data.Serialize.Text ()
import Data.Text (Text)
import Date.Date
import GHC.Generics

data TransactionType
  = Wants
  | Needs
  | Income
  | Investment
  deriving (Eq, Show)

instance Serialize TransactionType where
  put Wants = do
    put (0 :: Int16)
  put Needs = do
    put (1 :: Int16)
  put Income = do
    put (2 :: Int16)
  put Investment = do
    put (3 :: Int16)

  get = do
    t <- get :: Get Int16
    case t of
      0 -> return Wants
      1 -> return Needs
      2 -> return Income
      3 -> return Investment

data Transaction = Transaction
  { amount :: Double,
    date :: Date,
    transactionType :: TransactionType,
    description :: Text
  }
  deriving (Eq, Show)

instance Serialize Transaction where
  put (Transaction a dt t d) = do
    put a
    put dt
    put t
    put d

  get = do
    a <- get
    dt <- get
    t <- get :: Get TransactionType
    d <- get
    return $ Transaction a dt t d

data TransactionError
  = TransactionInitialization
  | TransactionGenericError
  deriving (Eq, Show)

mkTransaction ::
  Double ->
  Int8 ->
  Int8 ->
  Int16 ->
  TransactionType ->
  Text ->
  Either TransactionError Transaction
mkTransaction am da mo ye ty de =
  if (isRight dt)
    then Right $ Transaction am (extractDate dt) ty de
    else Left TransactionInitialization
  where
    dt = mkDate da mo ye

isTransactionType :: TransactionType -> Transaction -> Bool
isTransactionType ty t
  | transactionType t == ty = True
  | otherwise = False

evalTransaction :: Transaction -> Double -> Double
evalTransaction t acc = acc + amount t

evalTransactions :: [Transaction] -> Double
evalTransactions ts = foldr evalTransaction 0 ts

filterTransactionType :: TransactionType -> [Transaction] -> [Transaction]
filterTransactionType ty ts = filter (isTransactionType ty) ts

filterDate :: Date -> Date -> [Transaction] -> [Transaction]
filterDate start end ts = filter (\x -> start <= date x && end >= date x) ts

tranEx1 = mkTransaction 500 5 1 2021 Income "Work"

tranEx2 = mkTransaction (-50) 5 2 2021 Needs "Grocery shop"

tranEx3 = mkTransaction (-50) 5 3 2021 Wants "Restaurant"

tranEx = Transaction (500) (Date (Day 1) (Month 1) (Year 2021)) Income "Work"
