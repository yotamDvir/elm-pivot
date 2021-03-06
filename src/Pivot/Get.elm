module Pivot.Get exposing (getA, getC, getL, getR, hasL, hasR)

import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


getC : Pivot a -> a
getC (Pivot c _) =
    c


getL : Pivot a -> List a
getL (Pivot _ ( l, _ )) =
    List.reverse l


hasL : Pivot a -> Bool
hasL (Pivot _ ( l, _ )) =
    not (List.isEmpty l)


getR : Pivot a -> List a
getR (Pivot _ ( _, r )) =
    r


hasR : Pivot a -> Bool
hasR (Pivot _ ( _, r )) =
    not (List.isEmpty r)


getA : Pivot a -> List a
getA (Pivot c ( l, r )) =
    reversePrependList l (c :: r)
