module Pivot.Create exposing (..)

import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)
import Pivot.Get exposing (..)


fromList : List a -> Maybe (Pivot a)
fromList l =
    case l of
        hd :: tl ->
            fromCons hd tl
                |> Just

        [] ->
            Nothing


fromCons : a -> List a -> Pivot a
fromCons x xs =
    Pivot x ( [], xs )


(!!) =
    fromCons
infixr 5 !!


singleton : a -> Pivot a
singleton =
    flip fromCons []
