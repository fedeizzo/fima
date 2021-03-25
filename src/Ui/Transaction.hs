module Ui.Transaction where

import Brick
import Brick.Widgets.Center as C
import Data.Text (unpack)
import Data.Time (showGregorian)
import Data.Transaction.Transaction
import Data.Transaction.Type
import Graphics.Vty
  ( cyan,
    defAttr,
    green,
    magenta,
    red,
    yellow,
  )

tranStyleMap :: AttrMap
tranStyleMap = attrMap defAttr [(attrName "negative", fg red), (attrName "positive", fg green), (attrName "income", fg green), (attrName "needs", fg yellow), (attrName "wants", fg cyan), (attrName "investment", fg magenta)]

transactionRow :: Transaction -> Widget a
transactionRow t = hBox $ fmap C.hCenter [withAttr a_color $ str $ show $ amount t, str $showGregorian $ date t, withAttr t_color $ str $ show $ transactionType t, str $ unpack $ description t]
  where
    a_color = if amount t < (0 :: Double) then attrName "negative" else attrName "positive"
    t_color = case transactionType t of
      Income -> attrName "income"
      Needs -> attrName "needs"
      Wants -> attrName "wants"
      Investment -> attrName "investment"
