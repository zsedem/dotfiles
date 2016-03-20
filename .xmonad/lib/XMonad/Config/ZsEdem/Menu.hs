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
import XMonad.Util.NamedWindows(getName)
import qualified XMonad.StackSet as W
import XMonad.Util.Run(runProcessWithInput)
import XMonad.Actions.WindowBringer  (bringMenuArgs', gotoMenuArgs')
import XMonad.Actions.GroupNavigation(nextMatchOrDo, Direction(..))
import XMonad.Config.ZsEdem.Core


windowSwitchMenu, windowBringMenu :: X ()
windowSwitchMenu = gotoMenuArgs' dmenuBin dmenuArgs
windowBringMenu = bringMenuArgs' dmenuBin dmenuArgs

queryIsInTitle :: String -> Query Bool
queryIsInTitle windowNameMatcher = isSubsequenceOf windowNameMatcher <$> title

openWebPage :: String -> String -> X ()
openWebPage subString webpage = nextTitleMatchOrSpawn subString $ "google-chrome --app=http://" ++ webpage

nextTitleMatchOrSpawn :: String -> String -> X ()
nextTitleMatchOrSpawn windowSubTitle command = nextMatchOrDo
                                                    Forward
                                                    (queryIsInTitle windowSubTitle)
                                                    (loggedSpawn command)

menuArgs :: String -> [String] -> [String] -> X String
menuArgs menuCmd args opts = filter (/='\n') <$> runProcessWithInput menuCmd args (unlines opts)

customCommandMenu :: X ()
customCommandMenu = do
    windows <- windowMap
    layoutFiles <- filter (`notElem` [".", ".."] ) <$> liftIO (getDirectoryContents ".screenlayout")
    let commands = ["hangups", "pycharm", "term", "newtmux", "wifi off",
                    "chrome", "xmonad config", "review", "network", "wifi on",
                    "google", "openUrl"]
        windowPrefix = "window: "
        commandPrefix = "command: "
        screenLayoutPrefix = "screenlayout: "
        webPrefix = "web: "
        (|-) = isPrefixOf

        selections = concat
            [ map (commandPrefix++) commands
            , map (fst>>>(windowPrefix++)) windows
            , map (screenLayoutPrefix++) layoutFiles
            , map (fst>>>(webPrefix++)) webAppMap
            ]
    choosed <- menuArgs dmenuBin dmenuArgs selections
    spawn $ unwords ["echo '", choosed, "' >> .logs/yeganesh.log "]
    if  | "!" |- choosed -> loggedSpawn $ drop 1 choosed
        | windowPrefix |- choosed -> do
            let windowName = drop (length windowPrefix) choosed
            case lookup windowName windows of
                Just window -> focus window
                _ -> return ()
        | commandPrefix |- choosed -> do
            let command = drop (length commandPrefix) choosed
            commandRun command
        | screenLayoutPrefix |- choosed -> do
            let screenLayout = drop (length screenLayoutPrefix) choosed
                layoutFile = ".screenlayout/" ++ screenLayout
            loggedSpawn layoutFile
        | webPrefix |- choosed -> do
            let web = drop (length webPrefix) choosed
            case lookup web webAppMap of
                Just (substring, url) -> openWebPage substring url
                _ -> return ()
        | True -> spawn $ unwords ["notify-send 'Pattern Match Failure' '", choosed, ","]
  where
    terminalRun = nextMatchOrDo Forward (("st"==) <$> title) $ loggedSpawn "exec st -f 'Monofur for Powerline:size=19'"
    hangups = nextTitleMatchOrSpawn "hangups" "exec st -f 'Monofur for Powerline:size=19' -e hangups"
    getXselection = runProcessWithInput "xclip" ["-o", "-selection"] ""
    commandRun c | c `elem` ["hangups", "hangout"] = hangups
    commandRun "pycharm" = nextTitleMatchOrSpawn "PyCharm" "exec pycharm"
    commandRun c | c `elem` ["term", "st"] = terminalRun
    commandRun "google" = do
        selection <- getXselection
        let onelined = unwords $ lines selection
        loggedSpawn $ "xdg-open https://www.google.com/search?q='" ++ onelined ++ "'"
    commandRun "openUrl" = do
        selection <- getXselection
        loggedSpawn $ "xdg-open " ++ selection
    commandRun "newtmux" = loggedSpawn "exec st -f 'Monofur for Powerline:size=19' -e tmux"
    commandRun "chrome" = nextTitleMatchOrSpawn "chrome" "exec google-chrome"
    commandRun "xmonad config" = nextTitleMatchOrSpawn ".xmonad" "exec atom .xmonad"
    commandRun "review" = nextTitleMatchOrSpawn "review.balabit" "google-chrome  --incognito --app=https://review.balabit/#/q/project:bsp/bsp+status:open"
    commandRun "network" = loggedSpawn "nmcli_dmenu"
    commandRun ('w':'i':'f':'i':' ':switch)= wifi switch
    commandRun _ = return ()
    wifi switch = loggedSpawn $ "notify-send 'Wifi' `nmcli radio wifi " ++ switch ++ "`"

webAppMap :: [(String, (String, String))]
webAppMap =
    [ ("jenkins", ("Jenkins", "jenkins.bsp.balabit"))
    , ("mail", ("Inbox", "inbox.google.com"))
    , ("inbox", ("Inbox", "inbox.google.com"))
    , ("calendar", ("Calendar", "calendar.google.com"))
    , ("jira", ("Jira", "jira.balabit"))
    ]

loggedSpawn :: String -> X ()
loggedSpawn c = spawn $ "echo 'Spawn: "++c++ "'>> .logs/xmonad.log; " ++ c

dmenuRun :: String
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

dmenuBin = "yeganesh"
dmenuArgs = words "-p xmonadmenu -f -- -b -h 24 -l 9 -x 575 -y 342 -w 450 -nb #000000 -sb #0783c0 -dim 0.65"
