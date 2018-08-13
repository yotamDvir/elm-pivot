module Pivot.Create
    exposing
        ( fromCons
        , fromList
        , singleton
        )

import Pivot.Get exposing (..)
import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


fromList : List a -> Maybe (Pivot a)
fromList l =
    case l of
        [] ->
            Nothing

        hd :: tl ->
            Just (fromCons hd tl)


fromCons : a -> List a -> Pivot a
fromCons x xs =
    Pivot x ( [], xs )


singleton : a -> Pivot a
singleton x =
    fromCons x []
