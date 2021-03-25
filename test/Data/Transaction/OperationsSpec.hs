module Data.Transaction.OperationsSpec (spec) where

import Data.Text.Arbitrary
import Data.Time.Calendar
import Data.Transaction.Operations
import Data.Transaction.Type
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck hiding (Result)
import Test.QuickCheck.Property (Result, failed, succeeded)

instance Arbitrary Transaction where
  arbitrary = do
    a <- arbitrary :: Gen Double
    y <- elements ([2000 .. 3000] :: [Integer])
    m <- elements ([1 .. 12] :: [Int])
    d <- elements ([1 .. 28] :: [Int])
    let dt = fromGregorian y m d
    ty <- elements [Wants, Needs, Income, Investment]
    de <- arbitrary :: Gen Text
    return $ Transaction a dt ty de

instance Arbitrary TransactionType where
  arbitrary = elements [Wants, Needs, Income, Investment]

prop_mkTransaction :: Gen Result
prop_mkTransaction = do
  a <- arbitrary :: Gen Double
  y <- elements ([2000 .. 3000] :: [Integer])
  m <- elements ([1 .. 12] :: [Int])
  d <- elements ([1 .. 28] :: [Int])
  ty <- arbitrary :: Gen TransactionType
  de <- arbitrary :: Gen Text
  let dt = fromGregorian y m d
  let expected = Transaction a dt ty de
  let real = mkTransaction a y m d ty de
  return $ case real of
    (Right x) ->
      if x == expected
        then succeeded
        else failed
    (Left _) -> failed

prop_mkTransactionError :: Gen Result
prop_mkTransactionError = do
  a <- arbitrary :: Gen Double
  y <- elements ([2000 .. 3000] :: [Integer])
  m <- elements ([1 .. 12] :: [Int])
  d <- elements ([-100 .. 0] :: [Int])
  ty <- arbitrary :: Gen TransactionType
  de <- arbitrary :: Gen Text
  let expected = TransactionInitialization
  let real = mkTransaction a y m d ty de
  return $ case real of
    (Right _) -> failed
    (Left e) ->
      if e == expected
        then succeeded
        else failed

prop_evalTransactions :: Gen Result
prop_evalTransactions = do
  ts <- arbitrary :: Gen [Transaction]
  let expected = foldl (+) 0 $ fmap amount ts
  let real = evalTransactions ts
  return $
    if real == expected
      then succeeded
      else failed

spec :: Spec
spec = do
  describe "mkTransaction" $ do
    describe "with valid date" $ do
      prop "generates a new Transiction" $
        prop_mkTransaction
    describe "without valid date" $ do
      prop "returns transaction error" $
        prop_mkTransactionError
  describe "evalTransactions" $ do
    describe "with empty list" $ do
      it "returns 0" $
        evalTransactions [] `shouldBe` 0
    describe "with transactions list" $ do
      prop "returns total amount" $
        prop_evalTransactions
