{-# LANGUAGE OverloadedStrings #-}
module ChromeCommand where
import Data.Aeson
import qualified Data.Map   as M

data ChromeCommand = ChromeCommand
     { commandId     :: Int
     , commandMethod :: String
     , commandParams :: [(String, String)]
     } deriving (Show)


instance ToJSON ChromeCommand where
     toJSON cmd = object
         [ "id"     .= commandId cmd
         , "method" .= commandMethod cmd
         , "params" .= M.fromList (commandParams cmd)
         ]
