module XMonad.Config.ZsEdem.Keys
    ( keyBindings
    )
  where
import           Data.List(elemIndex)
import           Graphics.X11.Types
import           XMonad                         (X, kill, sendMessage,
                                                 spawn, windows, (.|.))
import           XMonad.Actions.WindowBringer   (bringMenuArgs', gotoMenuArgs')
import           XMonad.Hooks.ManageDocks       (ToggleStruts (..))
import qualified XMonad.Layout.WindowNavigation as W
import qualified XMonad.StackSet                as S
import qualified XMonad.Util.Run                as R
import           XMonad.Config.ZsEdem.Core      (workspaces)
import           XMonad.Config.ZsEdem.Menu


shift :: KeyMask -> KeyMask
shift m = m .|. shiftMask


alt :: KeyMask
alt = mod1Mask

ctrl :: KeyMask -> KeyMask
ctrl m = m .|. controlMask

windowsButton :: KeyMask
windowsButton = mod4Mask


keyBindings :: FilePath -> String -> String -> [((KeyMask, KeySym), X ())]
keyBindings homePath foregroundColor themeColor =
              [ ((mod4Mask .|. shiftMask, xK_p                          ), loggedSpawn dmenu_run)
              , ((mod4Mask              , xK_p                          ), menu [sWidth, sHeight, foregroundColor, themeColor])
              , ((mod4Mask              , xK_q                          ), spawn xmonad_restart)
              , ((mod4Mask .|. shiftMask, xK_q                          ), loggedSpawn powermenu)
              , ((windowsButton         , xK_Tab                        ), windows S.focusDown )
              , ((shift windowsButton   , xK_Tab                        ), windows S.focusUp )
              , ((windowsButton         , xK_Right                      ), sendMessage $ W.Swap W.R )
              , ((windowsButton         , xK_Left                       ), sendMessage $ W.Swap W.L )
              , ((windowsButton         , xK_Up                         ), sendMessage $ W.Swap W.U )
              , ((windowsButton         , xK_Down                       ), sendMessage $ W.Swap W.D )
              , ((alt                   , xK_F4                         ), kill )
              , ((windowsButton         , xK_F4                         ), kill )
              , ((windowsButton         , xK_F11                        ), sendMessage ToggleStruts )
              , ((alt                   , xK_Tab                        ), gotoMenuArgs' dmenu_run_file [sWidth, sHeight, foregroundColor, themeColor] )
              , ((shift alt             , xK_Tab                        ), bringMenuArgs' dmenu_run_file [sWidth, sHeight, foregroundColor, themeColor] )
              , ((controlMask           , xK_space                      ), layoutSwitch)
              , ((windowsButton         , xK_l                          ), spawn "xscreensaver-command -lock")
              , ((0                     , xMediaButton_AudioRewind      ), spawn "amixer -q set Master toggle" )
              , ((0                     , xF86MonBrightnessDown         ), spawn "xbacklight -5" )
              , ((0                     , xF86MonBrightnessUp           ), spawn "xbacklight +5" )
              , ((0                     , xMediaButton_AudioLowerVolume ), canberrabell $ spawn "amixer -q set Master 5%-" )
              , ((0                     , xMediaButton_AudioRaiseVolume ), canberrabell $ spawn "amixer -q set Master 5%+" )
              , ((ctrl shiftMask        , xK_q                          ), return ())
              ]  ++  [
                ((m .|. windowsButton, k), windows $ f i)
                   | (i, k) <- zip workspaces [xK_1 .. xK_9]
                   , (f, m) <- [(S.view, 0), (S.shift, shiftMask)]]
             where
                dmenu_run_file = homePath ++ dmenuBin
                dmenu_run = homePath ++ ".xmonad/assets/bin/dmenu-run.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"
                powermenu = homePath++".xmonad/assets/bin/powermenu.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"
                xmonad_restart = homePath++".xmonad/assets/bin/restart.sh"
                loggedSpawn c = spawn $ "echo '"++c++ "'>> /tmp/xmonad.spawn.log; " ++ c
                layoutSwitch = do keyboardlayout <- R.runProcessWithInput "/usr/bin/xkblayout-state" ["print", "%s"] ""
                                  let newLayout = nextItem ["us", "hu"] keyboardlayout
                                  spawn $ "setxkbmap " ++ newLayout
                canberrabell e          = spawn "canberra-gtk-play -i bell">> e

                xMediaButton_AudioRewind      = 0x1008ff3e
                xMediaButton_AudioLowerVolume = 0x1008ff11
                xMediaButton_AudioRaiseVolume = 0x1008ff13
                -- xMediaButton_Sleep            = 0x1008ff2f
                -- xMediaButton_Email            = 0x1008ff19
                -- xMediaButton_Search           = 0x1008ff1b
                -- xMediaButton_Home             = 0x1008ff18
                -- xMediaButton_Play             = 0x1008ff14
                -- xMediaButton_MyComputer       = 0x1008ff5d
                xF86MonBrightnessUp = 0x1008ff02
                xF86MonBrightnessDown = 0x1008ff03
                sWidth  = "1600"
                sHeight = "900"

nextItem :: (Eq a) => [a] -> a -> a
nextItem l item = case elemIndex item (init l) of
                    Just index -> l !! (index + 1)
                    Nothing -> head l
