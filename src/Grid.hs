{-# LANGUAGE TemplateHaskell, ViewPatterns #-}

import Control.Lens
import Control.Monad.State
import qualified Data.Vector as V

data Terrain = Mud | Grass | Water | Fire  

data Player = Player

-- data Grid = { cur :: Terrain, left :: Grid Terrain, right :: Grid Terrain, forward :: Grid Terrain, back :: Grid Terrain }

data Grid a = Grid { _cur :: a, _left :: Grid a, _right :: Grid a, _forward :: Grid a, _back :: Grid a }

makeLenses ''Grid

data Game = Game {_players :: [Player], _world :: Grid Terrain}

updateTerrain :: Grid Terrain -> Grid Terrain
updateTerrain g@(view cur -> Grass) = g & cur .~  Mud   