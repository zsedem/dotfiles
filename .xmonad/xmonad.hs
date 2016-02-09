{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Main(main) where
import           Text.Printf                    (printf)
import           System.Directory               (getHomeDirectory)
import           XMonad
import qualified XMonad.Config.ZsEdem           as ZsEdem
import           XMonad.Config.ZsEdem           (backgroundColor, foregroundColor, themeColor)
import           XMonad.Hooks.ManageDocks       (avoidStruts, docksEventHook)
import           XMonad.Layout.NoBorders        (smartBorders)
import           XMonad.Layout.Spacing          (spacing)
import           XMonad.Layout.WindowNavigation (windowNavigation)
import           XMonad.Util.EZConfig           (additionalKeys)
import           XMonad.Util.Run                (spawnPipe)
import           XMonad.Layout.Tabbed


sWidth :: Int
sWidth  = 1600

layoutHook' = avoidStruts $ smartBorders $ windowNavigation ( tabbed shrinkText ZsEdem.theme ||| sTall ||| Mirror mTall )
        where
            sTall = spacing 5 $ Tall 1 (3/100) (2/3)
            mTall = spacing 5 $ Tall 1 (3/100) (2/3)

main = do
    homePath <- (++"/")<$> getHomeDirectory
    spawn iBar
    layoutPanel <- spawnPipe lBar
    workspacePanel <- spawnPipe wBar
    xmonad $ defaultConfig
     { manageHook = ZsEdem.manageHook <+> manageHook defaultConfig
     , layoutHook = layoutHook'
     , modMask = mod4Mask
     , workspaces = ZsEdem.workspaces
     , focusFollowsMouse  = False
     , clickJustFocuses   = False
     , terminal = "urxvt"
     , focusedBorderColor = themeColor
     , normalBorderColor = "#424242"
     , borderWidth = 2
     , startupHook = ZsEdem.startupHook
     , logHook = ZsEdem.layoutDzenLogHook layoutPanel <+> ZsEdem.workspaceDzenLogHook workspacePanel
     , handleEventHook = docksEventHook <+> handleEventHook defaultConfig
     } `additionalKeys` ZsEdem.keyBindings homePath
     where
        dzenArgs = "-p -e 'button3=' -fn 'Droid Sans Fallback-8:bold'"
        lBar     = printf
                        "sleep 0.3;exec dzen2 %s -ta l -fg '%s' -bg '%s' -h 25 -w %d -y 0"
                        dzenArgs backgroundColor foregroundColor (sWidth // 2)
        iBar     = printf
                        "sleep 0.3; conky -c ~/.xmonad/assets/conky/info.conkyrc | dzen2 %s -ta r -fg '%s' -bg '%s' -h 25 -w %d -x %d -y 0"
                        dzenArgs backgroundColor foregroundColor (sWidth // 2) (sWidth // 2 )
        wBar     = printf
                        "sleep 0.6;exec dzen2 %s -ta c -fg '%s' -bg '%s' -h 20 -w 300 -x %d -y 4"
                        dzenArgs backgroundColor foregroundColor (sWidth // 2 - 150)
        (//)      = div
