module Main(main) where

import           XMonad
import qualified XMonad.Config.ZsEdem           as ZsEdem
import           XMonad.Hooks.ManageDocks       (avoidStruts, docksEventHook,
                                                 manageDocks)
import           XMonad.Layout.NoBorders        (smartBorders)
import           XMonad.Layout.Spacing          (spacing)
import           XMonad.Layout.WindowNavigation (windowNavigation)
import           XMonad.Util.EZConfig           (additionalKeys)
import           XMonad.Util.Run                (spawnPipe)

hPath = "/home/zsedem/"
clr1 = "#efefef"
clr2 = "#000000"
clr3 = "#0783c0"
sWidth  = "1600"
sHeight = "900"

layoutHook' = avoidStruts  $ smartBorders $ windowNavigation ( sTall ||| Mirror mTall ||| Full )
        where
            sTall = spacing 10 $ Tall 1 (3/100) (2/3)
            mTall = spacing 10 $ Tall 1 (3/100) (2/3)

main = do
    bgPanel <- spawnPipe bgBar
    layoutPanel <- spawnPipe lBar
    infoPanel <- spawnPipe iBar
    workspacePanel <- spawnPipe wBar
    xmonad $ defaultConfig
     { manageHook = ZsEdem.manageHook <+> manageDocks <+> manageHook defaultConfig
     , layoutHook = layoutHook'
     , modMask = mod4Mask
     , workspaces = ZsEdem.workspaces
     , focusFollowsMouse  = False
     , clickJustFocuses   = False
     , terminal = "urxvt"
     , focusedBorderColor = clr3
     , normalBorderColor = "#424242"
     , borderWidth = 3
     , startupHook = ZsEdem.startupHook
     , logHook = ZsEdem.layoutDzenLogHook layoutPanel <+> ZsEdem.workspaceDzenLogHook workspacePanel
     , handleEventHook    = handleEventHook defaultConfig <+> docksEventHook
     } `additionalKeys` ZsEdem.keyBindings
     where
        dzenArgs = "-p -e 'button3=' -fn 'Droid Sans Fallback-8:bold'"
        bgBar    = "echo '^fg("++clr3++")^p(;+20)^r(1600x5)' | dzen2 " ++ dzenArgs++" -ta c -fg '" ++ clr1 ++ "' -bg '#000000' -h 35 -w "++sWidth
        lBar     = "sleep 0.3;exec dzen2 "++dzenArgs++" -ta l -fg '"++clr1++"' -bg '" ++clr2++"' -h 25 -w `expr "++sWidth++" / 2` -y 0"
        iBar     = "sleep 0.3; conky -c ~/.xmonad/assets/conky/info.conkyrc | dzen2 "++dzenArgs++" -ta r -fg '"++clr1++"' -bg '" ++clr2++"' -h 25 -w `expr "++sWidth++" / 2` -x `expr "++sWidth++" / 2 - 50` -y 0"
        wBar     = "sleep 0.6;exec dzen2 "++dzenArgs++" -ta c -fg '"++clr1++"' -bg '" ++clr2++"' -h 20 -w 300 -x `expr "++sWidth++" / 2 - 150` -y 4"

