module XMonad.Config.ZsEdem.Core where
import           Data.Monoid                (Endo)
import           XMonad                     (Query, WindowSet, className,
                                             composeAll, (-->), (=?), (<+>))
import           XMonad.Actions.SpawnOn     (manageSpawn)
import           XMonad.Hooks.ManageHelpers (doFullFloat, doCenterFloat, isDialog)
import           XMonad.Layout.Decoration   (defaultTheme, Theme(..))
import           XMonad.Hooks.ManageDocks   (manageDocks)

theme :: Theme
theme =  defaultTheme
             { inactiveColor = black
             , activeColor = themeColor
             , urgentColor = black
             , inactiveBorderColor = themeColor
             , activeBorderColor = black
             , urgentBorderColor = red
             , urgentTextColor = red
             , fontName = "-Monofur for Powerline-*-*-*-*-12-*-*-*-*-*-*-*"
             }
    where
        black = "#000000"
        red = "#DD0000"

backgroundColor,foregroundColor,themeColor :: String
backgroundColor = "#efefef"
foregroundColor = "#000000"
themeColor = "#0783c0"

manageHook :: Query (Endo WindowSet)
manageHook = composeAll
            [ className =? "feh" --> doFullFloat
            , isDialog           --> doCenterFloat
            ] <+> manageSpawn <+> manageDocks

workspaces :: [String]
workspaces = makeOnclick [ "TERM", "WEB", "CODE"]
        where makeOnclick l = [ "^ca(1,xdotool key super+" ++ show n ++ ")" ++ ws ++ "^ca()" |
                                (i,ws) <- zip [(1::Int)..] l, let n = i ]
sWidth, sHeight :: String
sWidth  = "1600"
sHeight = "900"
