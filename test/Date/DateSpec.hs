module Date.DateSpec (spec) where

import Data.Int (Int16, Int8)
import Date.Date
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck hiding (Result)
import Test.QuickCheck.Property (Result, failed, succeeded)

prop_mkDate :: Gen Result
prop_mkDate = do
  d <- elements ([1 .. 31] :: [Int8])
  m <- elements ([1 .. 12] :: [Int8])
  y <- elements ([2000 .. 3000] :: [Int16])
  let dt = mkDate d m y
  let expected = Date (Day d) (Month m) (Year y)
  return $ case dt of
    (Right real) -> if real == expected then succeeded else failed
    (Left _) -> failed

prop_YearOutOfRange :: Gen Result
prop_YearOutOfRange = do
  d <- elements ([1 .. 31] :: [Int8])
  m <- elements ([1 .. 12] :: [Int8])
  y <- elements ([0 .. 1999] ++ [3001 .. 4000] :: [Int16])
  let dt = mkDate d m y
  return $ case dt of
    (Right _) -> failed
    (Left YearOutOfRange) -> succeeded
    (Left _) -> failed

prop_DayOutOfRange :: Gen Result
prop_DayOutOfRange = do
  d <- elements ([-100 .. 0] ++ [32 .. 100] :: [Int8])
  m <- elements ([1 .. 12] :: [Int8])
  y <- elements ([2000 .. 3000] :: [Int16])
  let dt = mkDate d m y
  return $ case dt of
    (Right _) -> failed
    (Left DayOutOfRange) -> succeeded
    (Left _) -> failed

prop_MonthOutOfRange :: Gen Result
prop_MonthOutOfRange = do
  d <- elements ([1 .. 31] :: [Int8])
  m <- elements ([- 100 .. 0] ++ [13 .. 100] :: [Int8])
  y <- elements ([2000 .. 3000] :: [Int16])
  let dt = mkDate d m y
  return $ case dt of
    (Right _) -> failed
    (Left MonthOutOfRange) -> succeeded
    (Left _) -> failed

spec :: Spec
spec = do
  describe "mkDate" $ do
    describe "with valid day, month and year" $ do
      prop "generates a new Date" $
        prop_mkDate
    describe "with valid day, month and invalid year" $ do
      prop "returns a YearOutOfRange" $
        prop_YearOutOfRange
    describe "with valid month, year and invalid day" $ do
      prop "returns a DayOutOfRange" $
        prop_DayOutOfRange
    describe "with valid day, year and invalid month" $ do
      prop "returns a MonthOutOfRange" $
        prop_MonthOutOfRange
