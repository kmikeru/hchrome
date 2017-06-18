{-# LANGUAGE OverloadedStrings #-}
module ChromeTabs where
import           Control.Applicative  ((<$>))
import           Control.Monad        (forever, mzero)
import           Data.Aeson            as A
import           Network.HTTP.Simple
import Data.Maybe(fromJust,fromMaybe)
import qualified Data.ByteString.Lazy as LBS

data ChromeTab = ChromeTab {
                  id :: String,
                  title :: String,
                  url :: String,
                  webSocketDebuggerUrl :: String
 } deriving (Show)

type ChromeTabs=[ChromeTab]

instance FromJSON ChromeTab where
  parseJSON (A.Object x) = ChromeTab <$> x .: "id"  <*> x .: "title" <*>  x .: "url" <*> x .: "webSocketDebuggerUrl"
  parseJSON _ = mzero

getJson::IO LBS.ByteString
getJson=do
     r<-httpLBS "http://127.0.0.1:9222/json/list/"
     let lbs=getResponseBody r
     return lbs

decodeJson::LBS.ByteString->Maybe [ChromeTab]
decodeJson lbs = A.decode lbs :: Maybe [ChromeTab]

getWSDebugUrl=do
                json<-getJson
                let tabs=decodeJson json
                let firstTab=(head $ fromJust tabs)
                return $ webSocketDebuggerUrl firstTab

