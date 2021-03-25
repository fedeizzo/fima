module Data.Transaction.Transaction
  ( Transaction,
    TransactionType,
    TransactionError,
    mkTransaction,
    evalTransactions,
    filterTransactionType,
    filterDate,
    amount,
    date,
    transactionType,
    description,
    t_example,
    t_example2,
    t_example3,
    t_example4,
  )
where

import Data.Text (pack)
import Data.Time.Calendar
import Data.Transaction.Operations
import Data.Transaction.Type

t_example :: Transaction
t_example = Transaction 500 (fromGregorian 2021 1 1) Income $ pack "Work"

t_example2 :: Transaction
t_example2 = Transaction (-100) (fromGregorian 2021 1 1) Wants $ pack "Coffee"

t_example3 :: Transaction
t_example3 = Transaction (-100) (fromGregorian 2021 1 1) Needs $ pack "Grocery"

t_example4 :: Transaction
t_example4 = Transaction 100 (fromGregorian 2021 1 1) Investment $ pack "ETF"
