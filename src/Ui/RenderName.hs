module Ui.RenderName where

data RenderName
  = AmountField
  | DateField
  | TransactionTypeField
  | DescriptionField
  | TransactionsList
  deriving (Show, Eq, Ord)
