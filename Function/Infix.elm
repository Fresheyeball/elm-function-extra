module Function.Infix exposing (..)

{-|
Elm is getting less functional, here is some relief
@docs (<$>), (<*>), (>>=)
-}

import Function

infixl 4 <$>
{-| map as an infix, like normal -}
(<$>) : (a -> b) -> (x -> a) -> x -> b
(<$>) = (<<)

infixl 5 <*>
{-| apply as an infix, like normal -}
(<*>) : (x -> a -> b) -> (x -> a) -> x -> b
(<*>) = flip Function.andMap

infixl 1 >>=
{-| bind as an infix, like normal -}
(>>=) : (x -> a) -> (a -> x -> b) -> x -> b
(>>=) = flip Function.andThen
