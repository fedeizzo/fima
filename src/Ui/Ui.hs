module Ui.Ui where

import Brick
import Brick.Forms (Form, renderForm)
import Brick.Main as M
import qualified Brick.Types as T
import Brick.Widgets.Border as B
import Brick.Widgets.Center as C
import Brick.Widgets.List as L
import Data.Sequence (Seq)
import Data.Transaction.Transaction
import qualified Graphics.Vty as V
import Ui.CommandsPanel
import Ui.RenderName
import Ui.Transaction as Tran

drawUi :: (L.List RenderName Transaction, Form Transaction e RenderName) -> [Widget RenderName]
drawUi s = [ui]
  where
    (l, t) = s
    ui = B.border $ hBox [hLimitPercent 66 transactions, B.vBorder, rightPanel]
    transactions = vBox [Tran.header, B.hBorder, L.renderList Tran.listDrawElement True l]
    rightPanel = vBox [commandsPanel, B.hBorder, renderForm t]

appEvent :: (L.List RenderName Transaction, Form Transaction e RenderName) -> T.BrickEvent RenderName e -> T.EventM RenderName (T.Next (L.List RenderName Transaction, Form Transaction e RenderName))
-- appEvent s (T.VtyEvent (V.EvKey V.KDown [])) = M.vScrollBy vp1Scroll 1 >> M.continue s
-- appEvent s (T.VtyEvent (V.EvKey V.KUp [])) = M.vScrollBy vp1Scroll (-1) >> M.continue s
-- appEvent s (T.VtyEvent (V.EvKey (V.KChar 'j') [])) = M.vScrollBy vp1Scroll 1 >> M.continue s
-- appEvent s (T.VtyEvent (V.EvKey (V.KChar 'k') [])) = M.vScrollBy vp1Scroll (-1) >> M.continue s
appEvent s (T.VtyEvent (V.EvKey V.KEsc [])) = M.halt s
appEvent s _ = M.continue s

commonStyle :: [(AttrName, V.Attr)]
commonStyle = []

app :: M.App (L.List RenderName Transaction, Form Transaction e RenderName) e RenderName
app =
  M.App
    { M.appDraw = drawUi,
      M.appStartEvent = return,
      M.appHandleEvent = appEvent,
      M.appAttrMap = const $ attrMap V.defAttr $ mconcat [commonStyle, Tran.style],
      M.appChooseCursor = M.neverShowCursor
    }
