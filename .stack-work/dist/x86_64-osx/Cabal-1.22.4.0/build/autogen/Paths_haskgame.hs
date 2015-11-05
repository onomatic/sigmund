module Paths_haskgame (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/PawToppu/haskgame/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/bin"
libdir     = "/Users/PawToppu/haskgame/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/lib/x86_64-osx-ghc-7.10.2/haskgame-0.1.0.0-2O83vaiVLS4KXlJ3nF5mMU"
datadir    = "/Users/PawToppu/haskgame/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/share/x86_64-osx-ghc-7.10.2/haskgame-0.1.0.0"
libexecdir = "/Users/PawToppu/haskgame/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/libexec"
sysconfdir = "/Users/PawToppu/haskgame/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "haskgame_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "haskgame_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "haskgame_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskgame_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskgame_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
