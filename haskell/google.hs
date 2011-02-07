
import Text.Regex.Posix ((=~))

pattern :: String -> [String]
pattern = filter_par . (flip (=~) $ "\\([a-z]+\\)|[a-z]")
  where filter_par = map (filter ((=~ "[a-z]") . show))

expand :: [String] -> [String]
expand ((x:[]):xs) = []
