module Pivot.Modify
    exposing
        ( appendGoL
        , appendGoR
        , appendL
        , appendListL
        , appendListR
        , appendR
        , removeGoL
        , removeGoR
        , setC
        , setL
        , setR
        , sort
        , sortWith
        , switchL
        , switchR
        )

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
    setL r_ |> mirror


switchL : Pivot a -> Maybe (Pivot a)
switchL pvt =
    removeGoL pvt |> Maybe.map (getC pvt |> appendGoL)


switchR : Pivot a -> Maybe (Pivot a)
switchR =
    switchL |> mirrorM


removeGoL : Pivot a -> Maybe (Pivot a)
removeGoL (Pivot c ( l, r )) =
    case l of
        [] ->
            Nothing

        hd :: tl ->
            Just (Pivot hd ( tl, r ))


removeGoR : Pivot a -> Maybe (Pivot a)
removeGoR =
    removeGoL |> mirrorM


appendL : a -> Pivot a -> Pivot a
appendL val (Pivot c ( l, r )) =
    Pivot c ( val :: l, r )


appendR : a -> Pivot a -> Pivot a
appendR val =
    appendL val |> mirror


appendGoL : a -> Pivot a -> Pivot a
appendGoL val (Pivot c ( l, r )) =
    Pivot val ( l, c :: r )


appendGoR : a -> Pivot a -> Pivot a
appendGoR val =
    appendGoL val |> mirror


appendListL : List a -> Pivot a -> Pivot a
appendListL xs =
    mapWholeL (\l -> List.append l (List.reverse xs))


appendListR : List a -> Pivot a -> Pivot a
appendListR xs =
    mapWholeR (\r -> List.append r xs)


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
