module XMonad.Config.ZsEdem.Startup(startupHook) where
import XMonad(spawn, X)
import XMonad.Util.SpawnOnce(spawnOnce)
import XMonad.Hooks.SetWMName(setWMName)

startupHook :: X ()
startupHook = do
    setWMName "LG3D"
    mapM_ execOnce
          [ "xrdb ~/.Xresources"
          , "xsetroot -cursor_name left_ptr"
          , "xscreensaver -no-splash"
          , "nitrogen --restore"
          , "compton --config ~/.config/compton.conf -b"
          , "urxvt"
          , "dunst -conf .dunstrc"]
    delayedExecOnce "nm-applet"
    spawnTrayer
    turnOnSuspendAutoLock
  where
        execOnce = spawnOnce . ("exec "++)
        delayedExecOnce = spawnOnce . ("sleep 0.5; exec "++)
        spawnTrayer   = spawn "pkill trayer; exec trayer --edge top --align right --width 50  --widthtype pixel --transparent true --height 25 --alpha 150 --tint 'rgba(0,0,0,0)'"
        turnOnSuspendAutoLock = execOnce "xss-lock -- xscreensaver -lock"
