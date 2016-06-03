module Function.Extra exposing (..)

{-|
## Compose a two parameter function with a single parameter function
@docs (>>>), (<<<)

## Compose a three parameter function with a single parameter function
@docs (>>>>), (<<<<)

## Function properties
@docs map, map2, map3, ap, andThen, singleton, on

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
ap : (x -> a -> b) -> (x -> a) -> x -> b
ap ff f x = ff x (f x)

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
