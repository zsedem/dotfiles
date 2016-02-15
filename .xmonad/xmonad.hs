{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Main(main) where
import           Text.Printf                    (printf)
import           System.Directory               (getHomeDirectory)
import           System.Taffybar.Hooks.PagerHints (pagerHints)
import           XMonad
import qualified XMonad.Config.ZsEdem           as ZsEdem
import           XMonad.Config.ZsEdem           (backgroundColor, foregroundColor, themeColor)
import           XMonad.Hooks.ManageDocks       (avoidStruts, docksEventHook,
                                                 manageDocks)
import           XMonad.Layout.NoBorders        (smartBorders)
import           XMonad.Layout.Spacing          (spacing)
import           XMonad.Layout.WindowNavigation (windowNavigation)
import           XMonad.Util.EZConfig           (additionalKeys)
import           XMonad.Hooks.EwmhDesktops      (ewmh)
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
    xmonad . ewmh . pagerHints $ defaultConfig
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
     , handleEventHook = docksEventHook <+> handleEventHook defaultConfig
     } `additionalKeys` ZsEdem.keyBindings homePath
     where

        (//)      = div
