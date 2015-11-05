{-# LANGUAGE TemplateHaskell, ViewPatterns #-}

import Control.Lens
import Control.Monad.State
import qualified Data.Vector as V

data Terrain = Mud | Grass | Water | Fire  

data Player = Player

data Indexed s a  = Ind s (s -> a) 

type FIndexed a s  = Main.Indexed s a


instance (Show a, Show s) => Show (Main.Indexed s a) where
    show (Ind s f) = "Ind: " ++ show s ++ " looking at: " ++ show (f s)

look :: Main.Indexed s a -> a
look (Ind s f) = f s 

seek :: (s -> s) -> Main.Indexed s a -> Main.Indexed s a 
seek f (Ind s g) = (Ind (f s) g) 

set x = seek (const x)


class Functor w => Comonad w where 
   leave :: w a -> a
   duplicate :: w a -> w (w a)

instance Functor (Main.Indexed s) where
   fmap f (Ind s g) = Ind s (f . g)


instance Comonad (Main.Indexed s) where
    leave (Ind s f) = f s
    duplicate (Ind s f) = Ind s (flip Ind $ f)

loose s f = fmap f $ duplicate s 

peek :: (s -> s) -> Main.Indexed s a -> a
peek f = leave . seek f 


indexedList = Ind (0) ((V.fromList [4,7,3,2]) V.!)

index :: (s -> i -> a) -> i -> (s -> Main.Indexed i a)
index f i = \x -> Ind i (f x) 

-- data Grid = { cur :: Terrain, left :: Grid Terrain, right :: Grid Terrain, forward :: Grid Terrain, back :: Grid Terrain }

data Grid a = Grid { _cur :: a, _left :: Grid a, _right :: Grid a, _forward :: Grid a, _back :: Grid a }

makeLenses ''Grid

data Game = Game {_players :: [Player], _world :: Grid Terrain}

updateTerrain :: Grid Terrain -> Grid Terrain
updateTerrain g@(view cur -> Grass) = g & cur .~  Mud   