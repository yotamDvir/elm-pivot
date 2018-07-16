module Pivot.Position exposing (..)

import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)
import Pivot.Get exposing (..)


goR : Pivot a -> Maybe (Pivot a)
goR (Pivot cx ( lt, rt )) =
    case rt of
        hd :: tl ->
            Pivot hd ( cx :: lt, tl )
                |> Just

        [] ->
            Nothing


goL : Pivot a -> Maybe (Pivot a)
goL =
    goR
        |> mirrorM


goBy : Int -> Pivot a -> Maybe (Pivot a)
goBy steps pvt =
    if steps == 0 then
        Just pvt
    else if steps > 0 then
        goR pvt |> Maybe.andThen (goBy (steps - 1))
    else
        goL pvt |> Maybe.andThen (goBy (steps + 1))


goTo : Int -> Pivot a -> Maybe (Pivot a)
goTo dest =
    goToStart >> goBy dest


goWhere : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
goWhere isIt =
    let
        go_ : Pivot a -> Maybe (Pivot a)
        go_ pvt =
            if isIt (getC pvt) then
               Just pvt
            else
                goR pvt |> Maybe.andThen go_
    in
        goToStart >> go_


goToStart : Pivot a -> Pivot a
goToStart pvt =
    case goL pvt of
        Just pvt_ ->
            goToStart pvt_

        Nothing ->
            pvt


goToEnd : Pivot a -> Pivot a
goToEnd =
    goToStart |> mirror


lengthL : Pivot a -> Int
lengthL =
    getL >> List.length


lengthR : Pivot a -> Int
lengthR =
    getR >> List.length


lengthA : Pivot a -> Int
lengthA =
    getA >> List.length
