module Data.Comonad where 

class Functor w => Comonad w where 
   leave :: w a -> a
   duplicate :: w a -> w (w a)
   loosen :: (w a) -> (w a -> b) -> w b