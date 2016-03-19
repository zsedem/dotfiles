{-# LANGUAGE MultiWayIf #-}
module XMonad.Config.ZsEdem.Menu
    ( customCommandMenu
    , dmenuRun
    , windowBringMenu
    , windowSwitchMenu
    , powerMenu
    , dmenuRunMenu
    ) where
import Control.Arrow((>>>))
import Data.List(isSubsequenceOf, isPrefixOf)
import Data.Char(toLower)
import System.Directory(getDirectoryContents)
import XMonad hiding(windows)
import XMonad.Util.Dmenu(menuArgs)
import XMonad.Util.NamedWindows(getName)
import qualified XMonad.StackSet as W
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
openWebPage subString webpage = nextTitleMatchOrSpawn subString $ "google-chrome --app=http://" ++ webpage

nextTitleMatchOrSpawn :: String -> String -> X ()
nextTitleMatchOrSpawn windowSubTitle command = nextMatchOrDo
                                                    Forward
                                                    (queryIsInTitle windowSubTitle)
                                                    (loggedSpawn command)

customCommandMenu :: X ()
customCommandMenu = do
    windows <- windowMap
    layoutFiles <- filter (`notElem` [".", ".."] ) <$> liftIO (getDirectoryContents ".screenlayout")
    let commands = ["jira", "hangups", "mail", "inbox", "pycharm", "term", "calendar", "newtmux",
                    "chrome", "xmonad config", "review", "network", "wifi", "jenkins",
                    "google", "openUrl"]
        windowPrefix = "window: "
        commandPrefix = "command: "
        screenLayoutPrefix = "screenlayout: "
        (|-) = isPrefixOf

        selections = concat
            [ map (commandPrefix++) commands
            , map (fst>>>(windowPrefix++)) windows
            , map (screenLayoutPrefix++) layoutFiles
            ]
    choosed <- menuArgs dmenuBin args selections
    if  | "!" |- choosed -> loggedSpawn $ drop 1 choosed
        | windowPrefix |- choosed -> do
            let windowName = drop (length windowPrefix) choosed
            case lookup windowName windows of
                Just window -> focus window
                Nothing -> return ()
        | commandPrefix |- choosed -> do
            let command = drop (length commandPrefix) choosed
            commandRun command
        | screenLayoutPrefix |- choosed -> do
            let screenLayout = drop (length screenLayoutPrefix) choosed
                layoutFile = ".screenlayout/" ++ screenLayout
            loggedSpawn layoutFile
  where
    args = [sWidth, sHeight, foregroundColor, themeColor]
    terminalRun = nextMatchOrDo Forward (("st"==) <$> title) $ loggedSpawn "exec st -f 'Monofur for Powerline:size=19'"
    hangups = nextTitleMatchOrSpawn "hangups" "exec st -f 'Monofur for Powerline:size=19' -e hangups"
    getXselection = runProcessWithInput "xclip" ["-o", "-selection"] ""
    commandRun "jira" = openWebPage "JIRA" "jira.balabit"
    commandRun "mail" = openWebPage "Inbox" "inbox.google.com"
    commandRun "inbox" = openWebPage "Inbox" "inbox.google.com"
    commandRun "calendar" = openWebPage "Calendar" "calendar.google.com"
    commandRun "hangups" = hangups
    commandRun "hangout" = hangups
    commandRun "jenkins" = openWebPage "Jenkins" "jenkins.bsp.balabit"
    commandRun "pycharm" = nextTitleMatchOrSpawn "PyCharm" "exec pycharm"
    commandRun "term" = terminalRun
    commandRun "st" = terminalRun
    commandRun "google" = do
        selection <- getXselection
        let onelined = unwords $ lines selection
        loggedSpawn $ "xdg-open https://www.google.com/search?q=['" ++ onelined ++ "']"
    commandRun "openUrl" = do
        selection <- getXselection
        loggedSpawn $ "xdg-open " ++ selection
    commandRun "newtmux" = loggedSpawn "exec st -f 'Monofur for Powerline:size=19' -e tmux"
    commandRun "chrome" = nextTitleMatchOrSpawn "chrome" "exec google-chrome"
    commandRun "xmonad config" = nextTitleMatchOrSpawn ".xmonad" "exec atom .xmonad"
    commandRun "review" = nextTitleMatchOrSpawn "review.balabit" "google-chrome  --incognito --app=https://review.balabit/#/q/project:bsp/bsp+status:open"
    commandRun "network" = loggedSpawn "nmcli_dmenu"
    commandRun "wifi" = do
        switch <- menuArgs dmenuBin args ["off", "on"]
        loggedSpawn $ "notify-send 'Wifi' `nmcli radio wifi " ++ switch ++ "`"
    commandRun _ = return ()

loggedSpawn :: String -> X ()
loggedSpawn c = spawn $ "echo 'Spawn: "++c++ "'>> .logs/xmonad.log; " ++ c

dmenuRunFile, dmenuRun :: String
dmenuRunFile = dmenuBin
dmenuRun = ".xmonad/assets/bin/dmenu-run.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"

dmenuRunMenu :: X ()
dmenuRunMenu = loggedSpawn dmenuRun

powerMenu :: X ()
powerMenu = loggedSpawn $ ".xmonad/assets/bin/powermenu.sh '"++sWidth ++"' '"++sHeight ++"' '"++foregroundColor++"' '"++themeColor++"'"


windowMap :: X [(String,Window)]
windowMap = do
    ws <- gets windowset
    mapM keyValuePair (W.allWindows ws)
  where
    keyValuePair w = flip (,) w . map toLower .show <$> getName w

