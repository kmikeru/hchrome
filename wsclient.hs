{-# LANGUAGE OverloadedStrings #-}
module Main  ( main ) where


--------------------------------------------------------------------------------
import           Control.Concurrent  (forkIO)
import           Control.Monad       (forever, unless)
import           Control.Monad.Trans (liftIO)
import           Network.Socket      (withSocketsDo)
import           Data.Text           (Text)
import qualified Data.Text           as T
import qualified Data.Text.IO        as T
import qualified Network.WebSockets  as WS

--let line="{"id":1,"method": "Page.navigate", "params": {"url": "http://google.com"}}"
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
main = withSocketsDo $ WS.runClient "127.0.0.1" 9222 "/devtools/page/b8b087e3-6b44-405f-ad13-aadba774c429" app
