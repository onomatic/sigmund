{-# LANGUAGE TemplateHaskell, ViewPatterns, MultiParamTypeClasses, TypeFamilies #-}

import Control.Lens
import qualified Data.Indexed as I
import qualified Data.Vector as V
import Data.Vector ((!))
import qualified Data.Coordinates as C

class (C.Coord co) => Grid grid co where

	type Elem grid :: *


	translate :: co -> (grid -> I.Indexed co (Elem grid))

	coords :: grid -> [co]



instance Grid (V.Vector v) (C.Point) where
    type Elem (V.Vector v) = v

    coords = undefined

    translate c = I.index' f c
             where f v (C.unP -> (x,y))  = v ! (x * 10 + y)   

{- 
data Terrain = Mud | Grass | Water | Fire  

data Player = Player

-- data Grid = { cur :: Terrain, left :: Grid Terrain, right :: Grid Terrain, forward :: Grid Terrain, back :: Grid Terrain }

data Grid a = Grid { _cur :: a, _left :: Grid a, _right :: Grid a, _forward :: Grid a, _back :: Grid a }

makeLenses ''Grid

data Game = Game {_players :: [Player], _world :: Grid Terrain}

updateTerrain :: Grid Terrain -> Grid Terrain
updateTerrain g@(view cur -> Grass) = g & cur .~  Mud 
-}  