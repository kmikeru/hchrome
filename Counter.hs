module Count where
import Data.IORef


makeCounter=newIORef (0::Int)
getCounter=readIORef
updateCounter c=modifyIORef c (+1)
