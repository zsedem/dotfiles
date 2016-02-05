module XMonad.Config.ZsEdem.Menu
    ( dmenuBin
    , queryIsInTitle
    , openWebPage
    , menu
    ) where
import XMonad(Query(..), title, X, spawn)
import XMonad.Util.Dmenu(menuArgs)
import XMonad.Actions.GroupNavigation(nextMatchOrDo, Direction(..))
import Data.List(isSubsequenceOf)


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

menu :: [String] -> X ()
menu args = do
    let commands = ["jira", "hangups", "mail", "pycharm", "term", "calendar", "newtmux",
                    "chrome", "xmonad config", "review", "network", "wifi"]
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
        "xmonad" -> nextTitleMatchOrSpawn ".xmonad" "exec atom .xmonad"
        "review" -> openWebPage "review.balabit" "review.balabit"
        "network" -> spawn "nmcli_dmenu"
        "wifi" -> do switch <- menuArgs dmenuBin args ["off", "on"]
                     spawn $ "notify-send 'Wifi' `nmcli radio wifi " ++ switch ++ "`"
        "" -> return ()
        ('!':command) -> spawn command
        custom -> spawn $ "xdg-open http://google.com/search?num=100&q=" ++ custom
