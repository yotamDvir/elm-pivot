module Pivot.Map exposing
  (..)


import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)
import Pivot.Get exposing (..)


mapCLR : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCLR onC onL onR =
  mapCLR' onC (List.map onL) (List.map onR)


mapCRL : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCRL onC =
  flip (mapCLR onC)


mapCS : (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCS onC onS =
  mapCLR onC onS onS


mapA : (a -> b) -> Pivot a -> Pivot b
mapA onA =
  mapCS onA onA


mapC : (a -> a) -> Pivot a -> Pivot a
mapC =
  flip mapCS identity


mapL : (a -> a) -> Pivot a -> Pivot a
mapL =
  mapCRL identity identity


mapR : (a -> a) -> Pivot a -> Pivot a
mapR f =
  mapL f
  |> mirror


mapS : (a -> a) -> Pivot a -> Pivot a
mapS =
  mapCS identity


mapCLR' : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapCLR' onC' onL' onR' pvt =
  Pivot (pvt |> getC |> onC') (pvt |> getL |> onL', pvt |> getR |> onR')


mapCRL' : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapCRL' onC' =
  flip (mapCLR' onC')


mapCS' : (a -> b) -> (List a -> List b) -> Pivot a -> Pivot b
mapCS' onC' onS' =
  mapCLR' onC' onS' onS'


mapL' : (List a -> List a) -> Pivot a -> Pivot a
mapL' =
  mapCRL' identity identity


mapR' : (List a -> List a) -> Pivot a -> Pivot a
mapR' f =
  mapL' f
  |> mirror


mapS' : (List a -> List a) -> Pivot a -> Pivot a
mapS' =
  mapCS' identity


apply : Pivot (a -> b) -> Pivot a -> Pivot b
apply (Pivot cf (lf, rf)) (Pivot c (l, r)) =
  let
    apList fs xs =
      List.concatMap (flip List.map xs) fs
  in
    Pivot (cf c) (apList lf l, apList rf r)
