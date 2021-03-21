{-# LANGUAGE OverloadedStrings #-}

module Date.Date where

import Data.Int
import Data.Serialize

newtype Day = Day Int8
  deriving (Eq, Ord, Show)

instance Serialize Day where
  put (Day d) = put d
  get = do
    d <- get
    return $ Day d

newtype Month = Month Int8
  deriving (Eq, Ord, Show)

instance Serialize Month where
  put (Month m) = put m
  get = do
    m <- get
    return $ Month m

newtype Year = Year Int16
  deriving (Eq, Ord, Show)

instance Serialize Year where
  put (Year y) = put y
  get = do
    y <- get
    return $ Year y

data Date = Date
  { getDay :: Day,
    getMonth :: Month,
    getYear :: Year
  }
  deriving (Eq, Show)

instance Ord Date where
  (>) x y =
    if (getYear x > getYear y) || (getYear x == getYear y) && (getMonth x > getMonth y)
      || (getYear x == getYear y) && (getMonth x == getMonth y) && (getDay x > getDay y)
      then True
      else False
  (<=) x y =
    if (getYear x > getYear y) || (getYear x == getYear y) && (getMonth x > getMonth y)
      || (getYear x == getYear y) && (getMonth x == getMonth y) && (getDay x > getDay y)
      then False
      else True

instance Serialize Date where
  put (Date d m y) = do
    put d
    put m
    put y
  get = do
    d <- get
    m <- get
    y <- get
    return $ Date d m y

data DateError
  = DayOutOfRange
  | MonthOutOfRange
  | YearOutOfRange
  | DateGenericError
  deriving (Eq, Show)

extractDate :: Either DateError Date -> Date
extractDate (Right dt) = dt
extractDate (Left _) = Date (Day 1) (Month 1) (Year 2000)

mkDate ::
  Int8 ->
  Int8 ->
  Int16 ->
  Either DateError Date
mkDate day month year
  | day < 1 || day > 31 = Left DayOutOfRange
  | month < 1 || month > 12 = Left MonthOutOfRange
  | year < 2000 || year > 3000 = Left YearOutOfRange
  | otherwise = Right $ Date (Day day) (Month month) (Year year)

dt1 = Date (Day 1) (Month 1) (Year 2018)

dt2 = Date (Day 1) (Month 2) (Year 2018)

dt3 = Date (Day 2) (Month 2) (Year 2018)

dt4 = Date (Day 2) (Month 2) (Year 2021)

dt5 = Date (Day 5) (Month 3) (Year 2021)
