{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Main(main) where
import Data.String.Utils
import System.Prompt.Color
import Text.Printf(printf)
import Control.Monad(when)
import Control.Lens
import Data.Time
import qualified System.Posix.User as U
import qualified Data.Map.Lazy as Map
import qualified System.Environment as Env
import System.FilePath
import System.Directory
import Data.Time.Lens

main :: IO ()
main = do
   environ <- Map.fromList <$> Env.getEnvironment
   putStr =<< (bashFormatting Green Bold . appendSpace) <$> U.getEffectiveUserName
   currentProject <- getCurrentProject
   (putStr . bashFormatting Blue Regular . appendSpace) currentProject
   when (null currentProject) $
        putStr =<< (bashFormatting Blue Regular . appendSpace) <$> getLocation
   putStr $ exitCodePart environ ++ " "
   putStr =<< (bashFormatting Yellow Bold . appendSpace) <$> getGitStatus environ
   putStr =<< (bashFormatting Red Regular . appendSpace) <$> getFormattedTime

appendSpace :: String -> String
appendSpace "" = ""
appendSpace l = l ++ " "

exitCodePart environ = if exitcode == "0"
                            then bashFormatting Green Regular ":)"
                            else bashFormatting Red Bold $ printf "(%s)" exitcode
  where exitcode = Map.findWithDefault "N/A" "last_exit_code" environ

getLocation = do
    currentDir <- getCurrentDirectory
    home <- getHomeDirectory
    let relativeCurrentDir = makeRelative home currentDir
        currentDirWithTilde = if home /= currentDir
                                then joinPath ["~", relativeCurrentDir]
                                else "~"
        currentDir' = (joinPath.reverse) $ zipWith (\i folder -> if i < 4 then folder
                                                                          else take 1 folder )
                                                   [(1::Int)..]
                                                   ((reverse.split "/") currentDirWithTilde)

    return currentDir'

getCurrentProject = do
    files <- filter (endswith cabal_extension) <$> getDirectoryContents "."
    case files of
        [] -> return ""
        (file:_) -> return $ join "" $ split ".cabal" file
  where cabal_extension = ".cabal"

getFormattedTime = do
    zonedTime <- getZonedTime
    let hour, minute, second :: Int
        hour = zonedTimeToLocalTime zonedTime ^. hours
        minute = zonedTimeToLocalTime zonedTime ^. minutes
        second = round $ zonedTimeToLocalTime zonedTime ^. seconds
    return $ printf "%d:%s:%s" hour (extendedShow minute) (extendedShow second)
  where extendedShow :: Int -> String
        extendedShow x | x < 10 = '0': show x
        extendedShow x = show x

getGitStatus environ = do
    let gitStatus = strip $ Map.findWithDefault "N/A" "git_status" environ
    return gitStatus
