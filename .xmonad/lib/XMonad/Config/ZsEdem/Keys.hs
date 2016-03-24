module XMonad.Config.ZsEdem.Keys
    ( keyBindings
    )
  where
import           Data.List                      (elemIndex)
import           Graphics.X11.Types
import           XMonad                         (X, kill, sendMessage, spawn,
                                                 windows, (.|.))
import           XMonad.Actions.CycleWindows    (cycleRecentWindows)
import           XMonad.Config.ZsEdem.Core
import           XMonad.Config.ZsEdem.Menu
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
keyBindings =
              [ ((mod4Mask .|. shiftMask, xK_p                          ), dmenuRunMenu)
              , ((mod4Mask              , xK_p                          ), customCommandMenu)
              , ((mod4Mask              , xK_q                          ), spawn xmonad_restart)
              , ((mod4Mask .|. shiftMask, xK_q                          ), powerMenu)
              , ((windowsButton         , xK_Tab                        ), cycleRecentWindows [xK_Super_L] xK_Tab xK_KP_Decimal)
              , ((windowsButton         , xK_Right                      ), sendMessage $ W.Swap W.R )
              , ((windowsButton         , xK_Left                       ), sendMessage $ W.Swap W.L )
              , ((windowsButton         , xK_Up                         ), sendMessage $ W.Swap W.U )
              , ((windowsButton         , xK_Down                       ), sendMessage $ W.Swap W.D )
              , ((windowsButton         , xK_h                          ), windows S.focusUp)
              , ((windowsButton         , xK_l                          ), windows S.focusDown)
              , ((windowsButton         , xK_w                          ), kill )
              , ((alt                   , xK_F4                         ), kill )
              , ((windowsButton         , xK_F4                         ), kill )
              , ((windowsButton         , xK_F11                        ), sendMessage ToggleStruts )
              , ((alt                   , xK_Tab                        ), windowSwitchMenu)
              , ((shift alt             , xK_Tab                        ), windowBringMenu)
              , ((controlMask           , xK_space                      ), layoutSwitch)
              , ((mod4Mask .|. shiftMask, xK_l                          ), spawn "hlock")
              , ((0                     , xMediaButton_AudioRewind      ), spawn "amixer -q set Master toggle" )
              , ((0                     , xF86MonBrightnessDown         ), spawn "xbacklight -5" )
              , ((0                     , xF86MonBrightnessUp           ), spawn "xbacklight +5" )
              , ((0                     , xMediaButton_AudioLowerVolume ), canberrabell $ spawn "amixer -q set Master 5%-" )
              , ((0                     , xMediaButton_AudioRaiseVolume ), canberrabell $ spawn "amixer -q set Master 5%+" )
              , ((ctrl shiftMask        , xK_q                          ), return ())
              ]  ++  workspaceSwitcherKeyBindings
             where
                xmonad_restart = "xmonad --restart"
                layoutSwitch = do keyboardlayout <- R.runProcessWithInput "/usr/bin/xkblayout-state" ["print", "%s"] ""
                                  let newLayout = nextItem ["us", "hu"] keyboardlayout
                                  spawn $ "setxkbmap " ++ newLayout
                canberrabell e = spawn "canberra-gtk-play -i bell">> e

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
                workspaceSwitcherKeyBindings = [
                    ((modifier .|. windowsButton, workspaceKeyCode), windows $ windowCommand workspaceName)
                        | (workspaceName, workspaceKeyCode) <- zip workspaces [xK_1 .. xK_9]
                        , (windowCommand, modifier) <- [(S.view, 0), (S.shift, shiftMask), (S.greedyView, mod1Mask)]]


nextItem :: (Eq a) => [a] -> a -> a
nextItem l item = case elemIndex item (init l) of
                    Just index -> l !! (index + 1)
                    Nothing -> head l
