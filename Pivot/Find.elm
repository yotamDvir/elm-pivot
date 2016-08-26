module Pivot.Find exposing
  (..)


import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)
import Pivot.Get exposing (..)
import Pivot.Position exposing (..)


firstWith : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
firstWith pred =
  goToStart >> findCR pred


lastWith : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
lastWith pred =
  firstWith pred
  |> mirrorM


findCR : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findCR pred pvt =
  if pvt |> getC |> pred
    then
      Just pvt
    else
      goR pvt `Maybe.andThen` findCR pred


findR : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findR pred pvt =
  goR pvt `Maybe.andThen` findCR pred


findCL : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findCL pred =
  findCR pred
  |> mirrorM


findL : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findL pred =
  findR pred
  |> mirrorM
