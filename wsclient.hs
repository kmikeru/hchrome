{-# LANGUAGE OverloadedStrings #-}
module Main  ( main ) where

import           Control.Monad.Trans (liftIO)
import           Network.Socket      (withSocketsDo)
import           Data.Text           (Text)
import qualified Data.Text           as T
import qualified Data.Text.IO        as T
import qualified Network.WebSockets  as WS
import qualified Data.Aeson as A
import ChromeTabs
import ChromeCommand

app :: WS.ClientApp ()
app conn = do
    putStrLn "Connected!"
    WS.sendTextData conn $ A.encode $ ChromeCommand {
	commandId=1,
	commandMethod="Page.navigate",
	commandParams=[("url","http://ya.ru")]
    }
    msg <- WS.receiveData conn
    liftIO $ T.putStrLn msg
    WS.sendClose conn ("Bye!" :: Text)


--------------------------------------------------------------------------------
main :: IO ()
main = do
    wsUrl <- getWSDebugPath
    withSocketsDo $ WS.runClient "127.0.0.1" 9222 wsUrl app
