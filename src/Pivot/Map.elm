module Pivot.Map exposing (apply, indexAbsolute, indexRelative, mapA, mapC, mapCLR, mapCRL, mapCS, mapL, mapR, mapS, mapWholeCLR, mapWholeCRL, mapWholeCS, mapWholeL, mapWholeR, mapWholeS)

import Pivot.Get exposing (..)
import Pivot.Position exposing (..)
import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


mapCLR : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCLR onC onL onR (Pivot c ( l, r )) =
    Pivot (onC c) ( List.map onL l, List.map onR r )


mapCRL : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCRL onC onR onL =
    mapCLR onC onL onR


mapCS : (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCS onC onS =
    mapCLR onC onS onS


mapA : (a -> b) -> Pivot a -> Pivot b
mapA onA =
    mapCS onA onA


mapC : (a -> a) -> Pivot a -> Pivot a
mapC onC =
    mapCS onC identity


mapL : (a -> a) -> Pivot a -> Pivot a
mapL =
    mapCRL identity identity


mapR : (a -> a) -> Pivot a -> Pivot a
mapR =
    mapCLR identity identity


mapS : (a -> a) -> Pivot a -> Pivot a
mapS =
    mapCS identity


mapWholeCLR : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapWholeCLR onC onL onR (Pivot c ( l, r )) =
    Pivot (onC c) ( onL l, onR r )


mapWholeCRL : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapWholeCRL onC onR onL =
    mapWholeCLR onC onL onR


mapWholeCS : (a -> b) -> (List a -> List b) -> Pivot a -> Pivot b
mapWholeCS onC onS =
    mapWholeCLR onC onS onS


mapWholeL : (List a -> List a) -> Pivot a -> Pivot a
mapWholeL =
    mapWholeCRL identity identity


mapWholeR : (List a -> List a) -> Pivot a -> Pivot a
mapWholeR =
    mapWholeCLR identity identity


mapWholeS : (List a -> List a) -> Pivot a -> Pivot a
mapWholeS =
    mapWholeCS identity


indexAbsolute : Pivot a -> Pivot ( Int, a )
indexAbsolute pvt =
    let
        n =
            lengthL pvt

        onC x =
            ( n, x )

        onL =
            List.indexedMap (\i x -> ( n - i - 1, x ))

        onR =
            List.indexedMap ((+) (n + 1) >> (\i x -> ( i, x )))
    in
    mapWholeCLR onC onL onR pvt


indexRelative : Pivot a -> Pivot ( Int, a )
indexRelative pvt =
    let
        onC x =
            ( 0, x )

        onL =
            List.indexedMap (\i x -> ( -1 - i, x ))

        onR =
            List.indexedMap (\i x -> ( i + 1, x ))
    in
    mapWholeCLR onC onL onR pvt


apply : Pivot (a -> b) -> Pivot a -> Pivot b
apply (Pivot cf ( lf, rf )) (Pivot c ( l, r )) =
    let
        apList fs xs =
            List.concatMap (\a -> List.map a xs) fs
    in
    Pivot (cf c) ( apList lf l, apList rf r )
