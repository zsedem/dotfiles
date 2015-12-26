module XMonad.Config.ZsEdem.UrgencyHook where
import XMonad(X, runQuery, Window, spawn, stringProperty)


urgencyHook :: Window -> X ()
urgencyHook window = do
    classProp <- getProperty "WM_CLASS"
    title <- getProperty "WM_NAME"
    
    spawn $ "notify-send '" ++ classProp ++" needs your attention' 'Title: " ++title++"'"
 where getProperty prop = runQuery (stringProperty prop) window
    