import Data.Maybe
import Data.List
import XMonad
import XMonad.Actions.CycleWindows
import XMonad.Actions.GroupNavigation

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeys)
import           XMonad.Layout.WindowNavigation  (Direction2D (..),
                                                  Navigate (..),
                                                  windowNavigation)
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified GHC.IO.Handle.Types as H

hPath = "/home/zsedem/"
clr1 = "#efefef"
clr2 = "#000000"
clr3 = "#0783c0"
sWidth  = "1600"
sHeight = "900"
makeSpace = wrap "    " "    "

myLogHook h = dynamicLogWithPP $ myPP h

myLogHook2 h = dynamicLogWithPP $ myPP2 h

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
                            )
    , ppOrder  = \(ws:l:t:_) -> [l,t]
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
    , ppOrder  = \(ws:l:t:_) -> [ws]
    }
    where
        wrapCurrent  = wrap ("^fg(#ffffff)^bg("++clr3++")") "^bg()^fg()"
        wrapAnother  = wrap "^fg(#cacaca)^bg(#424242)" "^bg()^fg()"

myWorkspace :: [String]
myWorkspace = makeOnclick [ " TERM ", " WEB ", " CODE "]
        where makeOnclick l = [ "^ca(1,xdotool key super+" ++ show n ++ ")" ++ ws ++ "^ca()" | (i,ws) <- zip [1..] l, let n = i ]


shift :: KeyMask -> KeyMask
shift m = m .|. shiftMask


alt :: KeyMask
alt = mod1Mask

ctrl :: KeyMask -> KeyMask
ctrl m = m .|. controlMask

windowsButton :: KeyMask
windowsButton = mod4Mask

myKeybinds = [ ((mod4Mask              , xK_p                          ), loggedSpawn dmenu_run)
             , ((mod4Mask              , xK_q                          ), spawn xmonad_restart)
             , ((mod4Mask .|. shiftMask, xK_q                          ), loggedSpawn powermenu)
             , ((windowsButton         , xK_Tab                        ), windows W.focusDown )
             , ((shift windowsButton   , xK_Tab                        ), windows W.focusUp )
             , ((windowsButton         , xK_Tab                        ), windows W.focusDown )
             , ((shift windowsButton   , xK_Tab                        ), windows W.focusUp )
             -- , ((shiftMask             , xK_Insert                     ), pasteSelection)
             , ((windowsButton         , xK_Right                      ), sendMessage $ Swap R )
             , ((windowsButton         , xK_Left                       ), sendMessage $ Swap L )
             , ((windowsButton         , xK_Up                         ), sendMessage $ Swap U )
             , ((windowsButton         , xK_Down                       ), sendMessage $ Swap D )
             , ((alt                   , xK_F4                         ), kill )
             , ((windowsButton         , xK_F4                         ), kill )
             , ((windowsButton         , xK_F11                        ), sendMessage ToggleStruts )
             , ((alt                   , xK_Tab                        ), nextMatch Backward (return True) )
             , ((shift alt             , xK_Tab                        ), nextMatch Forward (return True) )
             , ((controlMask           , xK_space                      ), layoutSwitch)
             ]
             where
                dmenu_run = hPath++".xmonad/assets/bin/dmenu-run.sh '"++sWidth ++"' '"++sHeight ++"' '"++clr2++"' '"++clr3++"'"
                powermenu = hPath++".xmonad/assets/bin/powermenu.sh '"++sWidth ++"' '"++sHeight ++"' '"++clr2++"' '"++clr3++"'"
                xmonad_restart = hPath++".xmonad/assets/bin/restart.sh"
                loggedSpawn c = spawn $ "echo '"++c++ "'>> /tmp/xmonad.spawn.log; " ++ c
                layoutSwitch = do keyboardlayout <- runProcessWithInput "/usr/bin/xkblayout-state" ["print", "%s"] ""
                                  let newLayout = nextItem ["us", "hu"] keyboardlayout
                                  spawn $ "setxkbmap " ++ newLayout
                                  

nextItem :: (Eq a) => [a] -> a -> a
nextItem l item = case elemIndex item (init l) of
                    Just index -> l !! (index + 1)
                    Nothing -> head l


myLayout = avoidStruts $ windowNavigation $ smartBorders ( sTall ||| Mirror mTall ||| Full )
        where
            sTall = spacing 10 $ Tall 1 (3/100) (2/3)
            mTall = spacing 10 $ Tall 1 (3/100) (2/3)

myDocks = composeAll
        	[ className =? "feh" --> doFullFloat
            , isDialog           --> doCenterFloat
            ]


main = do
    bgPanel <- spawnPipe bgBar
    layoutPanel <- spawnPipe lBar
    infoPanel <- spawnPipe iBar
    workspacePanel <- spawnPipe wBar
    xmonad $ defaultConfig
     { manageHook = myDocks <+> manageDocks <+> manageHook defaultConfig
     , layoutHook = myLayout
     , modMask = mod4Mask
     , workspaces = myWorkspace
     , terminal = "urxvt"
     , focusedBorderColor = clr3
     , normalBorderColor = "#424242"
     , borderWidth = 3
     , startupHook = spawnOnce autoload <+> 
                     spawn trayer <+>
                     setWMName "LG3D"
     , logHook = myLogHook layoutPanel <+> myLogHook2 workspacePanel
     , handleEventHook    = handleEventHook defaultConfig <+> docksEventHook
     } `additionalKeys` myKeybinds
     where
        autoload = hPath++"/.xmonad/assets/bin/autoload.sh"
        dzenArgs = "-p -e 'button3=' -fn 'Droid Sans Fallback-8:bold'"
        bgBar    = "echo '^fg("++clr3++")^p(;+20)^r(1600x5)' | dzen2 " ++ dzenArgs++" -ta c -fg '" ++ clr1 ++ "' -bg '#000000' -h 35 -w "++sWidth
        lBar     = "sleep 0.1;dzen2 "++dzenArgs++" -ta l -fg '"++clr1++"' -bg '" ++clr2++"' -h 25 -w `expr "++sWidth++" / 2` -y 0"
        iBar     = "sleep 0.1; conky -c ~/.xmonad/assets/conky/info.conkyrc | dzen2 "++dzenArgs++" -ta r -fg '"++clr1++"' -bg '" ++clr2++"' -h 25 -w `expr "++sWidth++" / 2` -x `expr "++sWidth++" / 2 - 50` -y 0"
        wBar     = "sleep 0.3;dzen2 "++dzenArgs++" -ta c -fg '"++clr1++"' -bg '" ++clr2++"' -h 20 -w 300 -x `expr "++sWidth++" / 2 - 150` -y 4"
        trayer   = "pkill trayer; trayer --edge top --align right --width 50  --widthtype pixel --transparent true --height 25 --alpha 150 --tint 'rgba(0,0,0,0)'"
