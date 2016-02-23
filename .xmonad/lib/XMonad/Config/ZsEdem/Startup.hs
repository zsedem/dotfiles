module XMonad.Config.ZsEdem.Startup(startupHook) where
import XMonad(spawn, X)
import XMonad.Hooks.SetWMName(setWMName)
import XMonad.Util.Run(runProcessWithInput)
import XMonad.Util.SpawnOnce(spawnOnce)

startupHook :: X ()
startupHook = do
    setWMName "LG3D"
    _ <- runProcessWithInput "xset" ["n", show 180, show 190] ""
    mapM_ execOnce
          [ "xsetroot -cursor_name left_ptr"
          , "xss-lock -n 'notify-send \"Idle Timout reached\"' -- slock"
          , "nitrogen --restore"
          , "compton --config ~/.config/compton.conf -b"
          , "dunst -conf .dunstrc"
          , "nm-applet"]
  where
        execOnce = spawnOnce . ("exec "++)
