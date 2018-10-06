module Pivot.Position exposing (goAbsolute, goL, goR, goRelative, goToEnd, goToStart, lengthA, lengthL, lengthR)

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


goRelative : Int -> Pivot a -> Maybe (Pivot a)
goRelative steps pvt =
    if steps == 0 then
        Just pvt

    else if steps > 0 then
        goR pvt |> Maybe.andThen (goRelative (steps - 1))

    else
        goL pvt |> Maybe.andThen (goRelative (steps + 1))


goAbsolute : Int -> Pivot a -> Maybe (Pivot a)
goAbsolute dest =
    goToStart >> goRelative dest


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
lengthL (Pivot _ ( l, _ )) =
    List.length l


lengthR : Pivot a -> Int
lengthR (Pivot _ ( _, r )) =
    List.length r


lengthA : Pivot a -> Int
lengthA (Pivot _ ( l, r )) =
    List.length l + 1 + List.length r
