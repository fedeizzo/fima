module Ui.CommandsPanel (commandsPanel) where

import Brick (Widget)
import Brick.Widgets.Border (hBorder)
import Brick.Widgets.Center (hCenter)
import Brick.Widgets.Core (str, vBox)

commandsPanel :: Widget n
commandsPanel = vBox [str "COMMANDS:", hBorder, vBox $ fmap hCenter [str "n: navigate transactions", str "i: insert new transaction", str "f: filter transactions", str "m: manage types mapping"]]
