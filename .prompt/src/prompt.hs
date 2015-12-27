module Main(main) where
import Data.String.Utils
import System.Prompt.Color
import Text.Printf(printf)
import Control.Monad()
import qualified System.Posix.User as U
import qualified Data.Map.Lazy as Map
import qualified  Data.Char as Char
import qualified System.Environment as Env
import System.FilePath
import System.Directory

main = do
   environ <- Map.fromList <$> Env.getEnvironment
   putStr " "
   putStr =<< bashFormatting Green Bold <$> U.getLoginName 
   putStr " "
   putStr =<< bashFormatting Cyan Regular <$> getLocation environ
   putStr " "
   putStr =<< bashFormatting Yellow Bold <$> getCurrentProject environ
   putStr " "
   putStr $ exitCodePart environ
   putStr "\n"
   putStr "> "

exitCodePart environ = if exitcode == "0" 
                            then bashFormatting Green Regular ":)"
                            else bashFormatting Red Bold $ printf "(%s)" exitcode
  where exitcode = Map.findWithDefault "N/A" "last_exit_code" environ

getLocation environ = do
    currentDir <- getCurrentDirectory
    home <- getHomeDirectory
    let relativeCurrentDir = makeRelative home currentDir
        currentDirWithTilde = if home /= currentDir 
                                then joinPath ["~", relativeCurrentDir]
                                else "~"
        currentDir' = (joinPath.reverse) $ zipWith (\i folder -> if i < 4 then folder
                                                                          else take 1 folder )
                                                   [1..]
                                                   ((reverse.split "/") currentDirWithTilde)

    return currentDir'

getCurrentProject environ = do
    files <- filter (endswith cabal_extension) <$> getDirectoryContents "."
    case files of 
        [] -> return ""
        (file:_) -> return $ join "" $ split ".cabal" file
  where cabal_extension = ".cabal"
