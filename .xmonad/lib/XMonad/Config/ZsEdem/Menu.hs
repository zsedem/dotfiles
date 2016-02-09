module XMonad.Config.ZsEdem.Menu
    ( customCommandMenu
    , dmenuRun
    , windowBringMenu
    , windowSwitchMenu
    , powerMenu
    , dmenuRunMenu
    ) where
import Data.List(isSubsequenceOf)
import System.Directory(getDirectoryContents)
import XMonad(Query(..), title, X, spawn, liftIO)
import XMonad.Util.Dmenu(menuArgs)
import XMonad.Actions.WindowBringer  (bringMenuArgs', gotoMenuArgs')
import XMonad.Actions.GroupNavigation(nextMatchOrDo, Direction(..))
import XMonad.Config.ZsEdem.Core


windowSwitchMenu, windowBringMenu :: X ()
windowSwitchMenu = gotoMenuArgs' dmenuRunFile [sWidth, sHeight, foregroundColor, themeColor]
windowBringMenu = bringMenuArgs' dmenuRunFile [sWidth, sHeight, foregroundColor, themeColor]

dmenuBin :: String
dmenuBin = ".xmonad/assets/bin/dmenu.sh"

queryIsInTitle :: String -> Query Bool
queryIsInTitle windowNameMatcher = do
    windowName <- title
    return $ isSubsequenceOf windowNameMatcher windowName

openWebPage :: String -> String -> X ()
openWebPage subString webpage = nextTitleMatchOrSpawn subString $ "xdg-open http://" ++ webpage

nextTitleMatchOrSpawn :: String -> String -> X ()
nextTitleMatchOrSpawn windowSubTitle command = nextMatchOrDo
                                                    Forward
                                                    (queryIsInTitle windowSubTitle)
                                                    (spawn command)

customCommandMenu :: X ()
customCommandMenu = do
    let commands = ["jira", "hangups", "mail", "pycharm", "term", "calendar", "newtmux",
                    "chrome", "xmonad config", "review", "network", "wifi"]
        args = [sWidth, sHeight, foregroundColor, themeColor]
    choosed <- menuArgs dmenuBin args commands
    let hangups = nextTitleMatchOrSpawn "hangups" "exec urxvt -e hangups"
    case choosed of
        "jira" -> openWebPage "JIRA" "jira.balabit"
        "mail" -> openWebPage "Inbox" "inbox.google.com"
        "calendar" -> openWebPage "Calendar" "calendar.google.com"
        "hangups" -> hangups
        "hangout" -> hangups
        "pycharm" -> nextTitleMatchOrSpawn "PyCharm" "exec pycharm"
        "term" -> nextTitleMatchOrSpawn "urxvt" "exec urxvt"
        "newtmux" -> spawn "exec urxvt -e tmux"
        "chrome" -> nextTitleMatchOrSpawn "chrome" "exec google-chrome"
        "xmonad config" -> nextTitleMatchOrSpawn ".xmonad" "exec atom .xmonad"
        "review" -> openWebPage "review.balabit" "review.balabit"
        "network" -> spawn "nmcli_dmenu"
        "wifi" -> do switch <- menuArgs dmenuBin args ["off", "on"]
                     spawn $ "notify-send 'Wifi' `nmcli radio wifi " ++ switch ++ "`"
        "screenlayout" -> do layoutFiles <- liftIO $ getDirectoryContents ".screenlayout"
                             let layouts = map (takeWhile (/='.')) layoutFiles
                             layout <- menuArgs dmenuBin args layouts
                             let layoutFile = ".screenlayout/" ++ layout ++ ".sh"
                             spawn layoutFile
        "" -> return ()
        ('!':command) -> spawn command
        custom -> spawn $ "xdg-open http://google.com/search?num=100&q=" ++ custom

loggedSpawn :: String -> X ()
loggedSpawn c = spawn $ "echo '"++c++ "'>> /tmp/xmonad.spawn.log; " ++ c

dmenuRunFile, dmenuRun :: String
dmenuRunFile = dmenuBin
dmenuRun = ".xmonad/assets/bin/dmenu-run.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"

dmenuRunMenu :: X ()
dmenuRunMenu = loggedSpawn $ dmenuRun

powerMenu :: X ()
powerMenu = loggedSpawn $ ".xmonad/assets/bin/powermenu.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"
