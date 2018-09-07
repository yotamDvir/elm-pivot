module Get exposing (..)

import Common.Units exposing (..)
import Expect as E
import Fuzz as F
import Pivot as P
import Pivot.Types exposing (Pivot(..))
import Test exposing (Test, describe, fuzz, fuzz2, fuzz3, only, skip, test)


getC : Test
getC =
    describe "getC" <|
        [ test "getC [1 2 *3* 4] == 3" <|
            \_ -> E.equal (P.getC p_1_2__3__4_) 3
        , fuzz (pivot F.string) "singleton >> getC == identity" <|
            \p -> E.equal ((P.singleton >> P.getC) p) p
        ]


getL : Test
getL =
    describe "getL" <|
        [ test "getL [1 2 *3* 4] == [1, 2]" <|
            \_ -> E.equal (P.getL p_1_2__3__4_) [ 1, 2 ]
        ]


getR : Test
getR =
    describe "getR" <|
        [ test "getR [1 2 *3* 4] == [4]" <|
            \_ -> E.equal (P.getR p_1_2__3__4_) [ 4 ]
        ]


getA : Test
getA =
    describe "getA" <|
        [ test "getA [1 2 *3* 4] == [1, 2, 3, 4]" <|
            \_ -> E.equal (P.getA p_1_2__3__4_) [ 1, 2, 3, 4 ]
        ]
