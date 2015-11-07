{-# LANGUAGE TypeFamilies, ViewPatterns #-}

module Data.Coordinates where


class Coord c where
    type Vect c :: *
    type Direction c :: *
    type Distance c :: *

    type instance Vect c = (Direction c, Distance c )

    distance :: c -> c -> Vect c

    move :: Vect c -> c -> c 

newtype Point = Point { unP :: (Int, Int) }

foldn :: Int -> (a -> a) -> a -> a
foldn 0 f a = a
foldn n f a = foldn (n - 1) f (f a)  

instance Coord Point where
    type Direction (Point) = (Point)
    type Distance (Point) = Int

    distance (unP -> (x,y)) (unP -> (x', y')) = (Point $ (dx , dy), 1)
                                       where dx = abs $ x - x'
                                             dy = abs $ y - y'

    move ((Point p), n) (p') = foldn n f p'
                       where f (unP -> (x, y)) = Point $ (,) (x + fst p) (y + snd p)                           