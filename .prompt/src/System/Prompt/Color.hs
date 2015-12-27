module System.Prompt.Color where
import qualified Text.Printf as P
import Debug.Trace


data BashColor = Black
               | Red
               | Green
               | Yellow
               | Blue
               | Purple
               | Cyan
               | White

data Style = Underline
           | Regular
           | Bold
           | Inverse

bashFormatting :: BashColor -> Style -> String -> String
bashFormatting color style = P.printf "\x1b[%s%sm%s\x1b[0m" color' style'
  where color' = bashColor color
        style' = case bashStyle style of
                    "" -> ""
                    str -> ";" ++ str

bashColor Black  = "30"
bashColor Red    = "31"
bashColor Green  = "32"
bashColor Yellow = "33"
bashColor Blue   = "34"
bashColor Purple = "35"
bashColor Cyan   = "36"
bashColor White  = "37"

bashStyle Underline  = "4"
bashStyle Regular    = "52"
bashStyle Bold       = "1"
bashStyle Inverse = "7"

