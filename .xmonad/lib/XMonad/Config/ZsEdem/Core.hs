module XMonad.Config.ZsEdem.Core
    ( manageHook
    , workspaces
    ) where
import           Data.Monoid                (Endo)
import           XMonad                     (Query, WindowSet, className,
                                             composeAll, (-->), (=?))
import           XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isDialog)

manageHook :: Query (Endo WindowSet)
manageHook = composeAll
            [ className =? "feh" --> doFullFloat
            , isDialog           --> doCenterFloat
            ]

workspaces :: [String]
workspaces = makeOnclick [ "TERM", "WEB", "CODE"]
        where makeOnclick l = [ "^ca(1,xdotool key super+" ++ show n ++ ")" ++ ws ++ "^ca()" |
                                (i,ws) <- zip [(1::Int)..] l, let n = i ]
