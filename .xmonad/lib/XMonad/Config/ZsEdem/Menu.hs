module XMonad.Config.ZsEdem.Menu
    ( customCommandMenu
    , dmenuRun
    , windowBringMenu
    , windowSwitchMenu
    , powerMenu
    , dmenuRunMenu
    ) where
import Data.List(isSubsequenceOf, unwords, lines)
import System.Directory(getDirectoryContents)
import XMonad(Query(..), title, X, spawn, liftIO)
import XMonad.Util.Dmenu(menuArgs)
import XMonad.Util.Run(runProcessWithInput)
import XMonad.Actions.WindowBringer  (bringMenuArgs', gotoMenuArgs')
import XMonad.Actions.GroupNavigation(nextMatchOrDo, Direction(..))
import XMonad.Config.ZsEdem.Core


windowSwitchMenu, windowBringMenu :: X ()
windowSwitchMenu = gotoMenuArgs' dmenuRunFile [sWidth, sHeight, foregroundColor, themeColor]
windowBringMenu = bringMenuArgs' dmenuRunFile [sWidth, sHeight, foregroundColor, themeColor]

dmenuBin :: String
dmenuBin = ".xmonad/assets/bin/dmenu.sh"

queryIsInTitle :: String -> Query Bool
queryIsInTitle windowNameMatcher = isSubsequenceOf windowNameMatcher <$> title

openWebPage :: String -> String -> X ()
openWebPage subString webpage = nextTitleMatchOrSpawn subString $ "xdg-open http://" ++ webpage

nextTitleMatchOrSpawn :: String -> String -> X ()
nextTitleMatchOrSpawn windowSubTitle command = nextMatchOrDo
                                                    Forward
                                                    (queryIsInTitle windowSubTitle)
                                                    (spawn command)

customCommandMenu :: X ()
customCommandMenu = do
    let commands = ["jira", "hangups", "mail", "inbox", "pycharm", "term", "calendar", "newtmux",
                    "chrome", "xmonad config", "review", "network", "wifi", "jenkins",
                    "screenlayout", "google", "openUrl"]
        args = [sWidth, sHeight, foregroundColor, themeColor]
        terminalRun = nextMatchOrDo Forward (("st"==) <$> title) $ spawn "exec st -f 'Monofur for Powerline:size=19'"
        hangups = nextTitleMatchOrSpawn "hangups" "exec st -f 'Monofur for Powerline:size=19' -e hangups"
    choosed <- menuArgs dmenuBin args commands
    case choosed of
        "jira" -> openWebPage "JIRA" "jira.balabit"
        "mail" -> openWebPage "Inbox" "inbox.google.com"
        "inbox" -> openWebPage "Inbox" "inbox.google.com"
        "calendar" -> openWebPage "Calendar" "calendar.google.com"
        "hangups" -> hangups
        "hangout" -> hangups
        "jenkins" -> openWebPage "Jenkins" "jenkins.bsp.balabit"
        "pycharm" -> nextTitleMatchOrSpawn "PyCharm" "exec pycharm"
        "term" -> terminalRun
        "st" -> terminalRun
        "google" -> do
            selection <- getXselection
            let onelined = unwords $ lines selection
            spawn $ "xdg-open https://www.google.com/search?q=['" ++ onelined ++ "']"
        "openUrl" -> do
            selection <- getXselection
            spawn $ "xdg-open " ++ selection
        "newtmux" -> spawn "exec st -f 'Monofur for Powerline:size=19' -e tmux"
        "chrome" -> nextTitleMatchOrSpawn "chrome" "exec google-chrome"
        "xmonad config" -> nextTitleMatchOrSpawn ".xmonad" "exec atom .xmonad"
        "review" -> nextTitleMatchOrSpawn "review.balabit" "google-chrome  --incognito --app=https://review.balabit/#/q/project:bsp/bsp+status:open"
        "network" -> spawn "nmcli_dmenu"
        "wifi" -> do switch <- menuArgs dmenuBin args ["off", "on"]
                     spawn $ "notify-send 'Wifi' `nmcli radio wifi " ++ switch ++ "`"
        "screenlayout" -> screenLayoutMenu args
        "" -> return ()
        ('!':command) -> spawn command
        custom -> spawn $ "xdg-open http://google.com/search?num=100&q=" ++ custom
  where
      getXselection = runProcessWithInput "xclip" ["-o", "-selection"] ""
loggedSpawn :: String -> X ()
loggedSpawn c = spawn $ "echo '"++c++ "'>> /tmp/xmonad.spawn.log; " ++ c

screenLayoutMenu :: [String] -> X ()
screenLayoutMenu args = do
    layoutFiles <- filter (`notElem` [".", ".."] ) <$> liftIO (getDirectoryContents ".screenlayout")
    let layouts = map (takeWhile (/='.')) layoutFiles
    layout <- menuArgs dmenuBin args layouts
    let layoutFile = ".screenlayout/" ++ layout ++ ".sh"
    spawn layoutFile

dmenuRunFile, dmenuRun :: String
dmenuRunFile = dmenuBin
dmenuRun = ".xmonad/assets/bin/dmenu-run.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"

dmenuRunMenu :: X ()
dmenuRunMenu = loggedSpawn $ dmenuRun

powerMenu :: X ()
powerMenu = loggedSpawn $ ".xmonad/assets/bin/powermenu.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"
