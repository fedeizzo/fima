{-# LANGUAGE OverloadedStrings #-}

module Main where

import Brick.Forms (Form)
import Brick.Main as M
import Brick.Widgets.List (List)
import Control.Monad.State
import Data.Either (isRight)
import Data.Sequence (fromList)
import Data.Text (Text)
import Data.Text.IO as T (getLine, putStr, putStrLn)
import Data.Time (fromGregorian)
import Data.Transaction.Transaction
import Data.Transaction.Type
import System.Posix.Env (getEnvDefault)
import Ui.RenderName
import Ui.Transaction
import Ui.Ui

-- loop :: StateT (Seq Transaction) IO ()
-- loop = do
--   liftIO $ T.putStrLn helpMessage
--   cmd <- liftIO $ T.getLine
--   case cmd of
--     "new" -> do
--       liftIO $ do
--         T.putStr "Amount: "
--         amount <- T.getLine
--         T.putStr "Day: "
--         day <- T.getLine
--         T.putStr "Month: "
--         month <- T.getLine
--         T.putStr "Year: "
--         year <- T.getLine
--         T.putStr "Transaction type: "
--         tranType <- T.getLine
--         T.putStr "Description: "
--         desc <- T.getLine
--         return ()
--       tran <- mkTransaction
--       modify (|> tranEx)
--       loop
--     "show" -> do
--       trans <- get
--       liftIO $ Prelude.putStrLn (show trans)
--       loop
--     "load" -> do
--       trans <- liftIO $ loadTransactions ".fima_data"
--       case trans of
--         (Right ts) -> put ts
--         (Left e) -> liftIO $ T.putStrLn "Error loading data!"
--       loop
--     "save" -> do
--       dataPath <- liftIO $ getEnvDefault "XDG_DATA_HOME" "./"
--       trans <- get
--       liftIO $ saveTransactions (dataPath ++ ".fima_data") trans
--       loop
--     "quit" -> return ()
--     _ -> liftIO $ T.putStrLn helpMessage
--   where
--     helpMessage =
--       "Commands:\n \
--       \\tnew: crate new transaction\n \
--       \\tshow: show transactions in memory\n \
--       \\tload: load transactions from file\n \
--       \\tsave: save transactions to file\n \
--       \\tquit: quit program"

-- main :: IO ()
-- main = runStateT loop (fromList [] :: Seq Transaction) >> return ()

initialForm :: Form Transaction e RenderName
initialForm = form $ Transaction 500 (fromGregorian 2021 1 1) Income "Prova"

initialList :: List RenderName Transaction
initialList = list $ fromList [t_example]

main :: IO ()
main = do
  void $ M.defaultMain app (initialList, initialForm)
