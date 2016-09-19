module Function.Extra exposing (..)

{-|
## Compose a two parameter function with a single parameter function
@docs (>>>), (<<<)

## Compose a three parameter function with a single parameter function
@docs (>>>>), (<<<<)

## Function properties
@docs map, map2, map3, map4, ap, andThen, singleton, on

## Reorder
@docs swirlr, swirll, flip3
-}

{-|
```elm
(\x y -> foo x y |> bar)
-- becomes
foo >>> bar
```
-}
(>>>) : (a -> b -> c) -> (c -> d) -> a -> b -> d
(>>>) ff f x y = ff x y |> f

{-|
```elm
(\x y -> bar <| foo x y)
-- becomes
bar <<< foo
```
-}
(<<<) : (c -> d) -> (a -> b -> c) -> a -> b -> d
(<<<) = flip (>>>)

{-|
```elm
(\x y z -> foo x y z |> bar)
-- becomes
foo >>>> bar
```
-}
(>>>>) : (a -> b -> c -> d) -> (d -> e) -> a -> b -> c -> e
(>>>>) fff f x y z = fff x y z |> f

{-|
```elm
(\x y z -> bar <| foo x y z)
-- becomes
bar <<<< foo
```
-}
(<<<<) : (d -> e) -> (a -> b -> c -> d) -> a -> b -> c -> e
(<<<<) = flip (>>>>)

{-|-}
map : (a -> b) -> (x -> a) -> x -> b
map = (<<)

{-|-}
map2 : (a -> b -> c) -> (x -> a) -> (x -> b) -> x -> c
map2 f a b = map f a `ap` b

{-|-}
map3 : (a -> b -> c -> d) -> (x -> a) -> (x -> b) -> (x -> c) -> x -> d
map3 f a b c = map f a `ap` b `ap` c

{-|-}
map4 : (a -> b -> c -> d -> e) -> (x -> a) -> (x -> b) -> (x -> c) -> (x -> d) -> x -> e
map4 f a b c d = map f a `ap` b `ap` c `ap` d

{-| Make a function that will call two functions on the same value and subsequently combine them.

Useful for longer chains, see the following examples: 

    f = (,) `map` sqrt `andMap` (\x -> x ^ 2)
    f 4 -- (2, 16)
    
    g = (,,) `map` toString `andMap` ((+) 1) `andMap` (\x -> x % 5)
    g 12 -- ("12",13,2)
-}
andMap : (x -> a -> b) -> (x -> a) -> x -> b
andMap ff f x = ff x (f x)

{-|
The functions are Monads and so should have an `andThen`.
-}
andThen : (a -> b) -> (b -> a -> c) -> a -> c
andThen f k x = k (f x) x

{-|
The functions are Monads and so should have a `singleton`.
-}
singleton : a -> b -> a
singleton = always

{-|
```elm
sortBy (compare `on` fst)
```
-}
on : (b -> b -> c) -> (a -> b) -> a -> a -> c
on g f = \x y -> f x `g` f y

{-|
```elm
foo = List.foldr (\a b -> bar a ++ baz b) 0 xs
--becomes
foo = swirlr List.foldr xs (\a b -> bar a ++ baz b) 0
```
-}
swirlr : (a -> b -> c -> d) -> c -> a -> b -> d
swirlr f c a b = f a b c

{-|
```elm
foo = List.foldr (\a b -> bar a ++ baz b) 0 xs
--becomes
foo = swirll List.foldr 0 xs
  <| \a b -> bar a ++ baz b
```
-}
swirll : (a -> b -> c -> d) -> b -> c -> a -> d
swirll f b c a = f a b c

{-|-}
flip3 : (a -> b -> c -> d) -> c -> b -> a -> d
flip3 f c b a = f a b c
