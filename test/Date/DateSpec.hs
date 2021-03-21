module Date.DateSpec (spec) where

import Data.Int (Int16, Int8)
import Date.Date
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck

instance Arbitrary a => Arbitrary (Date a) where
  arbitrary = do
    d <- arbitrary :: Int8
    m <- arbitrary :: Int8
    y <- arbitrary :: Int16
    return (Data d m y)

-- prop_mkDate :: Gen mkDate
-- prop_mkDate = do
--   d <- elements ([1 .. 31] :: [Int8])
--   m <- elements ([1 .. 31] :: [Int8])
--   y <- elements ([1 .. 31] :: [Int16])
--   (Right dt) <- mkDate d m y
--   return $ dt

spec :: Spec
spec = do
  describe "Date" $ do
    describe "mkDate" $ do
      describe "valid day, month and year" $ do
        prop "generates a new Date" $
          prop_mkDate
