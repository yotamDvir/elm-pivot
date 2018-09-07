module Find exposing (..)

import Common.Units exposing (..)
import Expect as E
import Fuzz as F
import Pivot as P
import Pivot.Types exposing (Pivot(..))
import Test exposing (Test, describe, fuzz, fuzz2, fuzz3, only, skip, test)


findR : Test
findR =
    describe "findR" <|
        [ test "findR ((==) 3) [1 2 *3* 4] == Nothing" <|
            \_ -> E.equal (P.findR ((==) 3) p_1_2__3__4_) Nothing
        ]


findL : Test
findL =
    describe "findL" <|
        [ test "findL ((==) 2) [1 2 *3* 4] == Just [1 *2* 3 4]" <|
            \_ -> E.equal (P.findL ((==) 2) p_1_2__3__4_) (Just p_1__2__3_4_)
        ]


findCR : Test
findCR =
    describe "findCR" <|
        [ test "findCR ((==) 3) [1 2 *3* 4] == Just [1 2 *3* 4]" <|
            \_ -> E.equal (P.findCR ((==) 3) p_1_2__3__4_) (Just p_1_2__3__4_)
        , fuzz2 F.string (pivot F.string) "firstWith pred == goToStart >> findCR pred" <|
            \str p -> E.equal (P.firstWith ((==) str) p) ((P.goToStart >> P.findCR ((==) str)) p)
        ]
