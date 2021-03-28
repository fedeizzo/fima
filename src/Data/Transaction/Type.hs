{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Data.Transaction.Type where

import Data.Either (rights)
import Data.Int
import Data.Serialize
import Data.Serialize.Text ()
import Data.Text (Text)
import Data.Time.Calendar (Day, fromGregorian, fromGregorianValid, toGregorian)
import Lens.Micro.TH

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
  { _amount :: Double,
    _date :: Day,
    _transactionType :: TransactionType,
    _description :: Text
  }
  deriving (Eq, Show)

makeLenses ''Transaction

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

instance Serialize Day where
  put day = do
    let (y, m, d) = toGregorian day
    put y
    put m
    put d

  get = do
    y <- get
    m <- get
    d <- get
    return $ fromGregorian y m d
