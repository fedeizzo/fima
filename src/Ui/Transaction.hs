module Ui.Transaction (header, style, form, Ui.Transaction.list, listDrawElement) where

import Brick
import Brick.Forms
import Brick.Widgets.Center as C
import Brick.Widgets.Core
import Brick.Widgets.List as L (List, list)
import Data.Foldable (toList)
import Data.Sequence as Se (Seq, fromList)
import Data.Text (unpack)
import Data.Time (showGregorian)
import Data.Transaction.Transaction
import Data.Transaction.Type
import Data.Vector as Vec (fromList)
import Graphics.Vty
  ( Attr,
    cyan,
    defAttr,
    green,
    magenta,
    red,
    yellow,
  )
import Lens.Micro.Extras (view)
import Ui.RenderName

header :: Widget n
header = vLimit 1 $ hBox $ fmap (C.center . str) ["Amount", "Date", "Type", "Desc"]

row :: Transaction -> Widget a
row t = hBox $ fmap C.hCenter [withAttr a_color $ str $ show $ view amount t, str $showGregorian $ view date t, withAttr t_color $ str $ show $ view transactionType t, str $ unpack $ view description t]
  where
    a_color = if view amount t < (0 :: Double) then attrName "negative" else attrName "positive"
    t_color = case view transactionType t of
      Income -> attrName "income"
      Needs -> attrName "needs"
      Wants -> attrName "wants"
      Investment -> attrName "investment"

listDrawElement :: Bool -> Transaction -> Widget RenderName
listDrawElement sel e = if sel then row e else row e

list :: Seq Transaction -> L.List RenderName Transaction
list ts = L.list TransactionsList (Vec.fromList $ toList ts) 1

form :: Transaction -> Form Transaction e RenderName
form =
  let label s w = padBottom (Pad 1) $ (vLimit 1 $ str s) <+> w
   in newForm
        [ label "desc" @@= editTextField description DescriptionField (Just 1)
        ]

style :: [(AttrName, Attr)]
style = [(attrName "negative", fg red), (attrName "positive", fg green), (attrName "income", fg green), (attrName "needs", fg yellow), (attrName "wants", fg cyan), (attrName "investment", fg magenta)]
