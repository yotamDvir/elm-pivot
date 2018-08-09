module Pivot.Position exposing (..)

import Pivot.Get exposing (..)
import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


goR : Pivot a -> Maybe (Pivot a)
goR (Pivot cx ( lt, rt )) =
    case rt of
        [] ->
            Nothing

        hd :: tl ->
            Just (Pivot hd ( cx :: lt, tl ))


goL : Pivot a -> Maybe (Pivot a)
goL =
    goR |> mirrorM


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


goToStart : Pivot a -> Pivot a
goToStart pvt =
    case goL pvt of
        Nothing ->
            pvt

        Just pvt_ ->
            goToStart pvt_


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
