module Data.Indexed where

import Data.Semigroup as S
import Data.Comonad
import Pipes

data Indexed i a  = Ind i (i -> a) 

instance (Show a, Show s) => Show (Indexed s a) where
    show (Ind s f) = "Ind: " ++ show s ++ " looking at: " ++ show (f s)

instance Functor (Indexed s) where
   fmap f (Ind s g) = Ind s (f . g)

instance Comonad (Indexed s) where
    leave (Ind s f) = f s
    duplicate (Ind s f) = Ind s (flip Ind $ f)
    loosen s f = fmap f $ duplicate s

look :: Indexed s a -> a
look = leave

seek :: (s -> s) -> Indexed s a -> Indexed s a 
seek f (Ind s g) = (Ind (f s) g) 

set = seek . const 

peek :: (s -> s) -> Indexed s a -> a
peek f = leave . seek f

peek' = peek . const   

index' :: (s -> i -> a) -> i -> (s -> Indexed i a)
index' f i = \x -> Ind i (f x) 

index :: Monoid i => (s -> i -> a) -> (s -> Indexed i a)
index f = \x -> Ind mempty (f x) 

-- Indexed is a non-commutative semigroup 
instance Monoid i => S.Semigroup (Indexed i a) where
   (Ind i f) <> (Ind i' f') = Ind (i `mappend` i') f