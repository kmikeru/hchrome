{-# LANGUAGE OverloadedStrings,FlexibleContexts #-}
module Main  ( main ) where

import           Control.Monad.Trans (liftIO)
import Control.Concurrent.Thread.Delay
import           Network.Socket      (withSocketsDo)
import           Data.Text           (Text)
import qualified Data.Text           as T
import qualified Data.Text.IO        as T
import qualified Network.WebSockets  as WS
import qualified Data.Aeson as A
import ChromeTabs
import ChromeCommand
import Counter

command0=ChromeCommand { commandId=0, commandMethod="Page.enable",commandParams=[]}
command1=ChromeCommand { commandId=0, commandMethod="Page.navigate",commandParams=[("url","http://ngs.ru")] }
command2=ChromeCommand { commandId=0, commandMethod="Page.navigate",commandParams=[("url","http://ya.ru")] }
commands=[command0,command1]

sendCommandWithWait conn cnt comm= do
    putStrLn "Sending!"
    updateCounter cnt
    counter<-getCounter cnt
    putStrLn $ show counter
    let commandWithCounter=comm { commandId=counter }
    WS.sendTextData conn (A.encode commandWithCounter)
    putStrLn "Sent, receiving"
    msg <- WS.receiveData conn
    putStrLn $ "Received:"++T.unpack(msg)
    delay 5000000

app :: WS.ClientApp ()
app conn = do
    putStrLn "Connected!"
    cnt<-makeCounter
    mapM (sendCommandWithWait conn cnt) commands
    WS.sendClose conn ("Bye!" :: Text)


--------------------------------------------------------------------------------
main :: IO ()
main = do
    wsUrl <- getWSDebugPath
    withSocketsDo $ WS.runClient "127.0.0.1" 9222 wsUrl app
