module Common.Units exposing (..)

import Fuzz as F exposing (Fuzzer)
import Pivot.Types exposing (Pivot(..))


literally : List a -> a -> List a -> Pivot a
literally l c r =
    Pivot c ( l, r )


p__1__2_3_4_ : Pivot Int
p__1__2_3_4_ =
    literally [] 1 [ 2, 3, 4 ]


p_1__2__3_4_ : Pivot Int
p_1__2__3_4_ =
    literally [ 1 ] 2 [ 3, 4 ]


p_1_2__3__4_ : Pivot Int
p_1_2__3__4_ =
    literally [ 2, 1 ] 3 [ 4 ]


p_1_2_3__4__ : Pivot Int
p_1_2_3__4__ =
    literally [ 3, 2, 1 ] 4 []


pivot : Fuzzer a -> Fuzzer (Pivot a)
pivot fuzzer =
    F.map3 literally (F.list fuzzer) fuzzer (F.list fuzzer)
