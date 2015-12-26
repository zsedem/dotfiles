module XMonad.Config.ZsEdem.Keys
    ( keyBindings
    )
  where
import           Data.List(elemIndex)
import           Graphics.X11.Types
import           XMonad                         (KeyMask, X, controlMask, kill,
                                                 mod1Mask, sendMessage,
                                                 shiftMask, spawn, windows,
                                                 (.|.))
import           XMonad.Actions.WindowBringer   (bringMenuArgs', gotoMenuArgs')
import           XMonad.Hooks.ManageDocks       (ToggleStruts (..))
import qualified XMonad.Layout.WindowNavigation as W
import qualified XMonad.StackSet                as S
import qualified XMonad.Util.Run                as R


shift :: KeyMask -> KeyMask
shift m = m .|. shiftMask


alt :: KeyMask
alt = mod1Mask

ctrl :: KeyMask -> KeyMask
ctrl m = m .|. controlMask

windowsButton :: KeyMask
windowsButton = mod4Mask


keyBindings :: [((KeyMask, KeySym), X ())]
keyBindings = [ ((mod4Mask              , xK_p                          ), loggedSpawn dmenu_run)
              , ((mod4Mask              , xK_q                          ), spawn xmonad_restart)
              , ((mod4Mask .|. shiftMask, xK_q                          ), loggedSpawn powermenu)
              , ((windowsButton         , xK_Tab                        ), windows S.focusDown )
              , ((shift windowsButton   , xK_Tab                        ), windows S.focusUp )
              -- , ((shiftMask             , xK_Insert                     ), pasteSelection)

              , ((windowsButton         , xK_Right                      ), sendMessage $ W.Swap W.R )
              , ((windowsButton         , xK_Left                       ), sendMessage $ W.Swap W.L )
              , ((windowsButton         , xK_Up                         ), sendMessage $ W.Swap W.U )
              , ((windowsButton         , xK_Down                       ), sendMessage $ W.Swap W.D )
              , ((alt                   , xK_F4                         ), kill )
              , ((windowsButton         , xK_F4                         ), kill )
              , ((windowsButton         , xK_F11                        ), sendMessage ToggleStruts )
              , ((alt                   , xK_Tab                        ), gotoMenuArgs' dmenu_run_file [sWidth, sHeight, clr2, clr3] )
              , ((shift alt             , xK_Tab                        ), bringMenuArgs' dmenu_run_file [sWidth, sHeight, clr2, clr3] )
              , ((controlMask           , xK_space                      ), layoutSwitch)
              , ((windowsButton         , xK_l                          ), spawn "xscreensaver-command -lock")
              , ((0                     , xMediaButton_AudioRewind      ), spawn "amixer -q set Master toggle" )
              , ((0                     , xMediaButton_AudioLowerVolume ), canberrabell $ spawn "amixer -q set Master 5%-" )
              , ((0                     , xMediaButton_AudioRaiseVolume ), canberrabell $ spawn "amixer -q set Master 5%+" )
              , ((ctrl shiftMask        , xK_q                          ), return ())
              ]
             where
                dmenu_run_file = hPath ++ ".xmonad/assets/bin/dmenu.sh"
                dmenu_run = hPath ++ ".xmonad/assets/bin/dmenu-run.sh '"++sWidth ++"' '"++sHeight ++"' '"++clr2++"' '"++clr3++"'"
                powermenu = hPath++".xmonad/assets/bin/powermenu.sh '"++sWidth ++"' '"++sHeight ++"' '"++clr2++"' '"++clr3++"'"
                xmonad_restart = hPath++".xmonad/assets/bin/restart.sh"
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
                hPath = "/home/zsedem/"
                clr2 = "#000000"
                clr3 = "#0783c0"
                sWidth  = "1600"
                sHeight = "900"

nextItem :: (Eq a) => [a] -> a -> a
nextItem l item = case elemIndex item (init l) of
                    Just index -> l !! (index + 1)
                    Nothing -> head l
