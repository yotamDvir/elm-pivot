module Pivot.Modify exposing (..)

import Pivot.Create exposing (..)
import Pivot.Get exposing (..)
import Pivot.Map exposing (..)
import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


setC : a -> Pivot a -> Pivot a
setC c_ (Pivot c ( l, r )) =
    Pivot c_ ( l, r )


setL : List a -> Pivot a -> Pivot a
setL l_ (Pivot c ( l, r )) =
    Pivot c ( List.reverse l_, r )


setR : List a -> Pivot a -> Pivot a
setR r_ =
    setL r_
        |> mirror


switchL : Pivot a -> Maybe (Pivot a)
switchL pvt =
    removeGoL pvt
        |> Maybe.map (pvt |> getC |> addGoL)


switchR : Pivot a -> Maybe (Pivot a)
switchR =
    switchL
        |> mirrorM


removeGoL : Pivot a -> Maybe (Pivot a)
removeGoL (Pivot c ( l, r )) =
    case l of
        hd :: tl ->
            Pivot hd ( tl, r )
                |> Just

        [] ->
            Nothing


removeGoR : Pivot a -> Maybe (Pivot a)
removeGoR =
    removeGoL
        |> mirrorM


addL : a -> Pivot a -> Pivot a
addL val (Pivot c ( l, r )) =
    Pivot c ( val :: l, r )


addR : a -> Pivot a -> Pivot a
addR val =
    addL val |> mirror


addGoL : a -> Pivot a -> Pivot a
addGoL val (Pivot c ( l, r )) =
    Pivot val ( l, c :: r )


addGoR : a -> Pivot a -> Pivot a
addGoR val =
    addGoL val |> mirror


sort : Pivot comparable -> Pivot comparable
sort =
    sortWith compare


sortWith : (a -> a -> Order) -> Pivot a -> Pivot a
sortWith compare (Pivot c ( l, r )) =
    let
        folder item ( l_, r_ ) =
            case compare item c of
                GT ->
                    ( l_, item :: r_ )

                _ ->
                    ( l_ ++ [ item ], r_ )
    in
    (l ++ r)
        |> List.sortWith compare
        |> List.foldr folder ( [], [] )
        |> Pivot c


{-| Appends a list to the end of the Right side of the Pivot
-}
appendList : List a -> Pivot a -> Pivot a
appendList xs =
    mapR_ (\rs -> List.foldl (::) rs xs)
