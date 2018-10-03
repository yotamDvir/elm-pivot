module Pivot.Get exposing (..)

import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


getC : Pivot a -> a
getC (Pivot c _) =
    c


getL : Pivot a -> List a
getL (Pivot _ ( l, _ )) =
    List.reverse l


hasL : Pivot a -> Bool
hasL =
    getL >> List.isEmpty >> not


hasLOptimized : Pivot a -> Bool
hasLOptimized (Pivot _ ( l, _ )) =
    not (List.isEmpty l)


getR : Pivot a -> List a
getR (Pivot _ ( _, r )) =
    r


hasR : Pivot a -> Bool
hasR =
    getR >> List.isEmpty >> not


hasROptimized : Pivot a -> Bool
hasROptimized (Pivot _ ( _, r )) =
    not (List.isEmpty r)


getA : Pivot a -> List a
getA (Pivot c ( l, r )) =
    List.reverse l ++ c :: r


getAOptimized : Pivot a -> List a
getAOptimized (Pivot c ( l, r )) =
    reversePrepend l (c :: r)


reversePrepend : List a -> List a -> List a
reversePrepend l1 l2 =
    case l1 of
        l :: ls ->
            reversePrepend ls (l :: l2)

        _ ->
            l2
