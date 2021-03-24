module Ui.Ui where

import Brick
import Brick.Main as M
import qualified Brick.Types as T
import Brick.Widgets.Border as B
import Brick.Widgets.Center as C
import qualified Graphics.Vty as V

data Name
  = VP1
  deriving (Ord, Show, Eq)

transactionRow :: Int -> Widget Name
-- transactionRow n = do
--   Widget Fixed Fixed $ do
--     ctx <- getContext
--     render $ str (show n <> " " <> show (availWidth ctx) <> "-")

transactionRow n = hBox $ fmap (C.hCenter . str) [show a <> " €", "01/01/2" <> show n, "type" <> show n, "desc" <> show n]
  where
    a = if n `mod` 3 == 0 then n else (- n)

transactionHeader :: Widget Name
transactionHeader = vLimit 1 $ hBox $ fmap (C.center . str) ["Amount", "Date", "Type", "Desc"]

drawUi :: () -> [Widget Name]
drawUi = const [ui]
  where
    ui = B.border $ hBox [hLimitPercent 66 transactions, B.vBorder, insert]
    transactions = vBox [vLimitPercent 50 transactionHeader, B.hBorder, viewport VP1 Vertical $ vBox $ fmap transactionRow [100 .. 200]]
    insert = vBox [str "I do not know", B.hBorder, str "The same here"]

vp1Scroll :: M.ViewportScroll Name
vp1Scroll = M.viewportScroll VP1

appEvent :: () -> T.BrickEvent Name e -> T.EventM Name (T.Next ())
appEvent _ (T.VtyEvent (V.EvKey V.KDown [])) = M.vScrollBy vp1Scroll 1 >> M.continue ()
appEvent _ (T.VtyEvent (V.EvKey V.KUp [])) = M.vScrollBy vp1Scroll (-1) >> M.continue ()
appEvent _ (T.VtyEvent (V.EvKey V.KEsc [])) = M.halt ()
appEvent _ _ = M.continue ()

app :: M.App () e Name
app =
  M.App
    { M.appDraw = drawUi,
      M.appStartEvent = return,
      M.appHandleEvent = appEvent,
      M.appAttrMap = const $ attrMap V.defAttr [],
      M.appChooseCursor = M.neverShowCursor
    }
