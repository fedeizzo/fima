{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.State
import qualified Data.ByteString as B
import Data.Either (isRight)
import Data.Sequence (fromList, Seq, (|>))
import Data.Serialize (decode, encode)
import Data.Text (Text)
import Data.Text.IO as T (getLine, putStr, putStrLn)
import Date.Date
import System.Posix.Env (getEnvDefault)
import Transaction.Transaction

saveTransactions :: String -> Seq Transaction -> IO ()
saveTransactions path ts = do
  B.writeFile path $ encode ts

loadTransactions :: String -> IO (Either String (Seq Transaction))
loadTransactions path = do
  ts <- B.readFile path
  return $ (decode ts :: Either String (Seq Transaction))

loop :: StateT (Seq Transaction) IO ()
loop = do
  liftIO $ T.putStrLn helpMessage
  cmd <- liftIO $ T.getLine
  case cmd of
    "new" -> do
      liftIO $ do
        T.putStr "Amount: "
        amount <- T.getLine
        T.putStr "Day: "
        day <- T.getLine
        T.putStr "Month: "
        month <- T.getLine
        T.putStr "Year: "
        year <- T.getLine
        T.putStr "Transaction type: "
        tranType <- T.getLine
        T.putStr "Description: "
        desc <- T.getLine
        return ()
      modify (|> tranEx)
      loop
    "show" -> do
      trans <- get
      liftIO $ Prelude.putStrLn (show trans)
      loop
    "load" -> do
      trans <- liftIO $ loadTransactions ".fima_data"
      case trans of
        (Right ts) -> put ts
        (Left e) -> liftIO $ T.putStrLn "Error loading data!"
      loop
    "save" -> do
      dataPath <- liftIO $ getEnvDefault "XDG_DATA_HOME" "./"
      trans <- get
      liftIO $ saveTransactions (dataPath ++ ".fima_data") trans
      loop
    "quit" -> return ()
    _ -> liftIO $ T.putStrLn helpMessage
  where
    helpMessage =
      "Commands:\n \
      \\tnew: crate new transaction\n \
      \\tshow: show transactions in memory\n \
      \\tload: load transactions from file\n \
      \\tsave: save transactions to file\n \
      \\tquit: quit program"

main :: IO ()
main = runStateT loop (fromList [] :: Seq Transaction) >> return ()