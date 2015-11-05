import Data.Semigroup as S

data Indexed s a  = Ind s (s -> a) 

type FIndexed a s  = Main.Indexed s a

instance (Show a, Show s) => Show (Indexed s a) where
    show (Ind s f) = "Ind: " ++ show s ++ " looking at: " ++ show (f s)

look :: Indexed s a -> a
look (Ind s f) = f s 

seek :: (s -> s) -> Indexed s a -> Indexed s a 
seek f (Ind s g) = (Ind (f s) g) 

set x = seek (const x)

class Functor w => Comonad w where 
   leave :: w a -> a
   duplicate :: w a -> w (w a)

instance Functor (Indexed s) where
   fmap f (Ind s g) = Ind s (f . g)

instance Comonad (Indexed s) where
    leave (Ind s f) = f s
    duplicate (Ind s f) = Ind s (flip Ind $ f)

loosen s f = fmap f $ duplicate s 

peek :: (s -> s) -> Indexed s a -> a
peek f = leave . seek f 

index' :: (s -> i -> a) -> i -> (s -> Indexed i a)
index' f i = \x -> Ind i (f x) 

index :: Monoid i => (s -> i -> a) -> (s -> Indexed i a)
index f = \x -> Ind mempty (f x) 

-- Indexed is a non-commutative semigroup 
instance Monoid i => S.Semigroup (Indexed i a) where
   (Ind i f) <> (Ind i' f') = Ind (i `mappend` i') f