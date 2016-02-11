module XMonad.Config.ZsEdem.Startup(startupHook) where
import XMonad(spawn, X)
import XMonad.Util.SpawnOnce(spawnOnce)
import XMonad.Hooks.SetWMName(setWMName)

startupHook :: X ()
startupHook = do
    setWMName "LG3D"
    mapM_ execOnce
          [ "xsetroot -cursor_name left_ptr"
          , "xscreensaver -no-splash"
          , "nitrogen --restore"
          , "compton --config ~/.config/compton.conf -b"
          , "dunst -conf .dunstrc"
          , "nm-applet"]
  where
        execOnce = spawnOnce . ("exec "++)
