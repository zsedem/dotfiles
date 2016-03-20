module XMonad.Config.ZsEdem.Core where
import           Data.Monoid                (Endo)
import           XMonad                     (Query, WindowSet, className,
                                             composeAll, def, (-->), (<+>),
                                             (=?))
import           XMonad.Actions.SpawnOn     (manageSpawn)
import           XMonad.Hooks.ManageDocks   (manageDocks)
import           XMonad.Hooks.ManageHelpers (doCenterFloat, doFullFloat,
                                             isDialog)
import           XMonad.Layout.Decoration   (Theme (..))

theme :: Theme
theme =  def
             { inactiveColor = black
             , activeColor = themeColor
             , urgentColor = black
             , inactiveBorderColor = themeColor
             , activeBorderColor = black
             , urgentBorderColor = red
             , urgentTextColor = red
             , decoHeight = 30
             , decoWidth = 30
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
workspaces = [ "TERM", "WEB", "CODE"]

sWidth, sHeight :: String
sWidth  = "1600"
sHeight = "900"
