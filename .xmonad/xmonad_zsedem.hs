import           XMonad
import           XMonad.Config.Gnome             (gnomeConfig)
import           XMonad.Util.Paste               (pasteSelection)
import           XMonad.Actions.CycleWS          (Direction1D (Prev, Next),
                                                  WSType (..), moveTo)
import           XMonad.Actions.CycleRecentWS
import           XMonad.Actions.GroupNavigation
import           XMonad.Actions.PerWorkspaceKeys
import           XMonad.Actions.PhysicalScreens  (PhysicalScreen, sendToScreen,
                                                  viewScreen)
import           XMonad.Actions.Search           (google, hoogle, namedEngine,
                                                  prefixAware,
                                                  promptSearchBrowser, (!>))
import           XMonad.Hooks.DynamicLog         (defaultPP, dynamicLogString,
                                                  xmobar, xmonadPropLog)
import           XMonad.Hooks.EwmhDesktops       (ewmh)
import           XMonad.Hooks.ManageDocks        (ToggleStruts (..),
                                                  docksEventHook, manageDocks)
import           XMonad.Hooks.ManageHelpers      (composeOne, doCenterFloat,
                                                  doFullFloat, isDialog,
                                                  isFullscreen, (-?>))
import           XMonad.Hooks.SetWMName          (setWMName)
import           XMonad.Layout.NoBorders         (noBorders, smartBorders)
import           XMonad.Layout.WindowNavigation  (Direction2D (..),
                                                  Navigate (..),
                                                  windowNavigation)
import           XMonad.Prompt                   (XPConfig (..),
                                                  XPPosition (..),
                                                  defaultXPConfig,
                                                  greenXPConfig)
import           XMonad.Prompt.Input
import           XMonad.Prompt.Shell             (shellPrompt)
import qualified XMonad.StackSet                 as W
import           XMonad.Util.CustomKeys          (customKeys)
import           XMonad.Util.SpawnOnce           (spawnOnce)
--Just to be sure that the compiler optimize these
{-# INLINE myManageHook #-}
{-# INLINE myWorkSpaces #-}
{-# INLINE shift #-}
{-# INLINE alt #-}
{-# INLINE ctrl #-}
{-# INLINE insKeys #-}
{-# INLINE delKeys #-}
{-# INLINE promptXPConfig #-}
{-# INLINE startup #-}
{-# INLINE workspaceKeys #-}
{-# INLINE windowsToFloat #-}

myWorkSpaces, windowsToFloat :: [String]
myWorkSpaces = ["One", "Two", "Three"]
windowsToFloat  = ["Adl","feh","File-roller","Xmessage","Volti"]

classNameIn :: [String] -> Query Bool
classNameIn  = foldr ((<||>) . (className =?)) (return False)

windowsButton :: KeyMask
windowsButton = mod4Mask -- windows button

main :: IO ()
main = xmonad =<< xmobar (gnomeConfig
       { modMask            = windowsButton
       , terminal           = "gnome-terminal --hide-menubar"
       , normalBorderColor  = "#333333"
       , focusedBorderColor = "#1793d1"
       , focusFollowsMouse  = False
       , clickJustFocuses   = True
       , workspaces         = myWorkSpaces
       , borderWidth        = 2
       , layoutHook         = smartBorders myLayoutHook
       , manageHook         = manageHook gnomeConfig -- NOTE: <+> is executed from right to left
                           <+> myManageHook
                           <+> manageDocks
       , logHook            = dynamicLogString defaultPP >>= xmonadPropLog
       , keys               = customKeys delKeys insKeys
       , startupHook        = setWMName "LG3D" >> startup
       , handleEventHook    = handleEventHook gnomeConfig <+> docksEventHook
       } )
  where
    myLayoutHook = windowNavigation tiled ||| windowNavigation mirrored  ||| full
           where mirrored = Mirror (Tall nmast delta ratio)
                 tiled    = Tall nmast delta ratio
                 nmast    = 1
                 delta    = 0.07
                 ratio    = 0.7
                 full     = noBorders  Full

-- | Rules for the new windows in tiling
myManageHook :: ManageHook
myManageHook = composeOne
    [ isFullscreen                        -?> doFullFloat
    , isDialog                            -?> doNothing
    , classNameIn windowsToFloat          -?> doCenterFloat
    ]
    where 
      doNothing           = return mempty

delKeys :: XConfig Layout -> [(KeyMask, KeySym)]
delKeys _ =
    [ (shift windowsButton , xK_p)
    , (windowsButton       , xK_r)
    ] ++ workspaceKeys

workspaceKeys :: [(KeyMask, KeySym)]
workspaceKeys = zip (replicate 9 (shift windowsButton)) [xK_1 .. xK_9]



shift :: KeyMask -> KeyMask
shift m = m .|. shiftMask


alt :: KeyMask
alt = mod1Mask

ctrl :: KeyMask -> KeyMask
ctrl m = m .|. controlMask

insKeys :: XConfig Layout -> [((KeyMask, KeySym), X ())]
insKeys _ =
    -- Prompts
    [ ((windowsButton      , xK_p                          ), shellPrompt promptXPConfig )
    , ((shift windowsButton, xK_p                          ), inputPrompt defaultXPConfig "$ " ?+ commandInNotify)
    , ((ctrl windowsButton , xK_p                          ), promptSearchBrowser
                                                              greenXPConfig
                                                              "google-chrome-stable"
                                                              ( namedEngine "hs" hoogle !> prefixAware google))

    , ((windowsButton       , xK_Tab                        ), windows W.focusDown )
    , ((shift windowsButton , xK_Tab                        ), windows W.focusUp )
    , ((alt                 , xK_Tab                        ), cycleRecentWS [xK_Alt_L] xK_Tab xK_grave)
    , ((alt                 , xK_Tab                        ), bindOn [ ("Chrome", windows W.focusUp)
                                                                 , (""      , nextMatch Forward (return True)
                                                                   )
                                                                 ]
      )
    , ((shift alt           , xK_Tab                        ), bindOn [ ("Chrome", windows W.focusDown)
                                                                 , (""      , nextMatch Backward (return True)
                                                                   )
                                                                 ]
      )
    , ((shiftMask           , xK_Insert                     ), pasteSelection)
    , ((windowsButton       , xK_Right                      ), sendMessage $ Swap R )
    , ((windowsButton       , xK_Left                       ), sendMessage $ Swap L )
    , ((windowsButton       , xK_Up                         ), sendMessage $ Swap U )
    , ((windowsButton       , xK_Down                       ), sendMessage $ Swap D )
    , ((alt                 , xK_F4                         ), kill )
    , ((windowsButton       , xK_F4                         ), kill )
    , ((windowsButton       , xK_F11                        ), sendMessage ToggleStruts )
    -- Workspace
    , ((ctrl alt            , xK_Down                       ), moveNext )
    , ((ctrl alt            , xK_Up                         ), movePrev )
    -- Screen
    , ((shift windowsButton , xK_Left                       ), windowToScreen 0 )
    , ((shift windowsButton , xK_Right                      ), windowToScreen 1 )
    , ((ctrl alt            , xK_Left                       ), viewScreen 0 )
    , ((ctrl alt            , xK_Right                      ), viewScreen 1 )
    -- Power managment
    , ((shift windowsButton , xK_l                          ), spawn "xscreensaver-command -lock" )
    , ((shift windowsButton , xK_F4                         ), spawn "canberra-gtk-play -i service-logout"
                                                                >> spawn "$HOME/.xmonad/closewindows.sh"
                                                                >> notifyspawn "sleep 60; systemctl poweroff" )
    , ((ctrl alt            , xK_F4                         ), spawn "canberra-gtk-play -i service-logout"
                                                                >> notifyspawn "sleep 1; systemctl poweroff" )
    , ((ctrl alt            , xK_Delete                     ), notifyspawn "sleep 3; systemctl reboot" )
    , ((0                   , xK_Pause                      ), notifyspawn "systemctl suspend" )
    , ((0                   , xMediaButton_Sleep            ), notifyspawn "systemctl suspend" )
    -- Sound
    , ((0                   , xMediaButton_AudioRewind      ), notifyspawn "amixer -q set Master toggle" )
    , ((0                   , xMediaButton_AudioLowerVolume ), canberrabell $ spawn "amixer -q set Master 5%-" )
    , ((0                   , xMediaButton_AudioRaiseVolume ), canberrabell $ spawn "amixer -q set Master 5%+" )

    -- Applications
    , ((controlMask         , xK_KP_Up                      ), nextMatchOrDo
                                                                Forward
                                                                (className =? "Gnome-terminal")
                                                                (spawn "gnome-terminal --hide-menubar"))
    , ((0                   , xMediaButton_Email            ), notifyspawn "skype" )
    , ((0                   , xMediaButton_Search           ), notifyspawn "google-chrome-stable" )
    , ((0                   , xMediaButton_Home             ), notifyspawn "gnome-terminal" )
    , ((0                   , xMediaButton_Play             ), notifyspawn "vlc" )
    , ((0                   , xMediaButton_MyComputer       ), notifyspawn "nautilus" )
    --Workspace grab with shift windowsButton + 0,1,...
    ] ++ zip workspaceKeys (map changeWorkspace myWorkSpaces)
    where
      --Screen/Workspace manage
      windowToScreen :: PhysicalScreen -> X ()
      windowToScreen scr = do sendToScreen scr
                              viewScreen scr
      moveNext :: X ()
      moveNext           = do viewScreen 0
                              moveTo Next HiddenNonEmptyWS
      movePrev :: X ()
      movePrev           = do viewScreen 0
                              moveTo Prev HiddenNonEmptyWS
      changeWorkspace worksp  = windows (W.shift worksp) >> windows (W.greedyView worksp)
      --Media buttons
      xMediaButton_AudioRewind      = 0x1008ff3e
      xMediaButton_AudioLowerVolume = 0x1008ff11
      xMediaButton_AudioRaiseVolume = 0x1008ff13
      xMediaButton_Sleep            = 0x1008ff2f
      xMediaButton_Email            = 0x1008ff19
      xMediaButton_Search           = 0x1008ff1b
      xMediaButton_Home             = 0x1008ff18
      xMediaButton_Play             = 0x1008ff14
      xMediaButton_MyComputer       = 0x1008ff5d
      --Notify
      commandInNotify :: String -> X ()
      commandInNotify str     = spawn ( "notify-send \""++str++"\" \"$("++str++")\"" )
                                >> spawn "canberra-gtk-play -i message"
      notifyspawn s           = spawn ("notify-send --expire-time=1 Spawn \""++s++"\"; "++s)
                                >> spawn "canberra-gtk-play -i message"
      canberrabell e          = spawn "canberra-gtk-play -i bell">> e

promptXPConfig :: XPConfig
promptXPConfig = defaultXPConfig
  { height            = 30
  , fgHLight          = "#3493f3"
  , bgHLight          = "#333333"
  , promptBorderWidth = 0
  , position          = Top
  }

startup :: X ()
startup =
    do spawn "canberra-gtk-play -i service-login"
       spawnOnce "$HOME/.xmonad/startup.sh"
