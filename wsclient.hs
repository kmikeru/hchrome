{-# LANGUAGE OverloadedStrings #-}
module Main  ( main ) where

import           Control.Monad.Trans (liftIO)
import           Network.Socket      (withSocketsDo)
import           Data.Text           (Text)
import qualified Data.Text           as T
import qualified Data.Text.IO        as T
import qualified Network.WebSockets  as WS
import ChromeTabs

line="{\"id\":1,\"method\": \"Page.navigate\", \"params\": {\"url\": \"http://google.com\"}}"
--------------------------------------------------------------------------------
app :: WS.ClientApp ()
app conn = do
    putStrLn "Connected!"
    WS.sendTextData conn (T.pack line)
    msg <- WS.receiveData conn
    liftIO $ T.putStrLn msg
    WS.sendClose conn ("Bye!" :: Text)


--------------------------------------------------------------------------------
main :: IO ()
main = do
    wsUrl <- getWSDebugPath
    withSocketsDo $ WS.runClient "127.0.0.1" 9222 wsUrl app
