module XMonad.Config.ZsEdem.LogHooks
    ( layoutDzenLogHook
    , workspaceDzenLogHook
    ) where
import XMonad(X)
import           XMonad.Hooks.DynamicLog
import           XMonad.Util.Run

import           System.IO

clr3 :: String
clr3 = "#0783c0"


makeSpace :: String -> String
makeSpace = wrap "    " "    "
layoutDzenLogHook, workspaceDzenLogHook :: Handle -> X ()
layoutDzenLogHook h = dynamicLogWithPP $ myPP h

workspaceDzenLogHook h = dynamicLogWithPP $ myPP2 h

myPP :: Handle -> PP
myPP p = defaultPP
    { ppOutput             = hPutStrLn p
    , ppSep                = ""
    , ppTitle              = titleWrapper . makeSpace . shorten 111
    , ppLayout             = buttonLayout . makeSpace .
                            ( \t -> case t of
                            "Spacing 10 Grid"           -> dir_icon ++ "grid.xbm)  Grid"
                            "Spacing 10 Tall"           -> dir_icon ++ "sptall.xbm)  Tile"
                            "Mirror Spacing 10 Tall"    -> dir_icon ++ "mptall.xbm)  mTile"
                            "Mirror Spacing 20 Tall"    -> dir_icon ++ "mptall.xbm)  rTile"
                            "Full"                      -> dir_icon ++ "full.xbm)  Full"
                            _ -> t
                            )
    , ppOrder  = \(_:l:t:_) -> [l,t]
    }
    where
        titleWrapper = wrap ("^fg("++clr3++")^i(.xmonad/assets/xbm/mr1.xbm)^fg()") ""
        buttonLayout = wrap ("^ca(1,xdotool key super+space)^bg("++clr3++")") "^bg()^ca()"
        dir_icon     = "^ca(1,xdotool key alt+space)^i(.xmonad/assets/xbm/"


myPP2 :: Handle -> PP
myPP2 h = defaultPP
    { ppOutput             = hPutStrLn h
    , ppCurrent            = wrapCurrent . makeSpace
    , ppVisible            = wrapAnother . makeSpace
    , ppHidden             = wrapAnother . makeSpace
    , ppHiddenNoWindows    = wrapAnother . makeSpace
    , ppWsSep              = "  "
    , ppOrder  = \(ws:_:_:_) -> [ws]
    }
    where
        wrapCurrent  = wrap ("^fg(#ffffff)^bg("++clr3++")") "^bg()^fg()"
        wrapAnother  = wrap "^fg(#cacaca)^bg(#424242)" "^bg()^fg()"
