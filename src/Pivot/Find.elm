module Pivot.Find exposing (findCL, findCR, findL, findR, firstWith, lastWith)

import Pivot.Get exposing (..)
import Pivot.Position exposing (..)
import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


firstWith : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
firstWith pred =
    goToStart >> findCR pred


lastWith : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
lastWith pred =
    firstWith pred |> mirrorM


findCR : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findCR pred pvt =
    if pred (getC pvt) then
        Just pvt

    else
        goR pvt |> Maybe.andThen (findCR pred)


findR : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findR pred pvt =
    goR pvt |> Maybe.andThen (findCR pred)


findCL : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findCL pred =
    findCR pred |> mirrorM


findL : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findL pred =
    findR pred |> mirrorM
