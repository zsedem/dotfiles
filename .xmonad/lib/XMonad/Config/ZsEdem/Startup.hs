module XMonad.Config.ZsEdem.Startup(startupHook) where
import           XMonad                 (X)
import           XMonad.Hooks.SetWMName (setWMName)
import           XMonad.Util.Run        (runProcessWithInput)
import           XMonad.Util.SpawnOnce  (spawnOnce)

startupHook :: X ()
startupHook = do
    setWMName "LG3D"
    _ <- runProcessWithInput "xset" ["n", "180", "190"] ""
    mapM_ execOnce
          [ "xsetroot -cursor_name left_ptr"
          , "nitrogen --restore"
          , "compton --config ~/.config/compton.conf -b"
          , "xss hlock"
          , "dunst -conf .dunstrc"
          , "nm-applet"]
  where
        execOnce = spawnOnce . ("exec "++)
