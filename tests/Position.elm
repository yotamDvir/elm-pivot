module Position exposing (..)

import Common.Units exposing (..)
import Expect as E
import Fuzz as F
import Pivot as P
import Pivot.Types exposing (Pivot(..))
import Test exposing (Test, describe, fuzz, fuzz2, fuzz3, only, skip, test)


goR : Test
goR =
    only <|
        describe "goR" <|
            [ test "goR [1 2 3 *4*] == Nothing" <|
                \_ -> E.equal (P.goR p_1_2_3__4__) Nothing
            , test "goR [1 *2* 3 4] == Just [1 2 *3* 4]" <|
                \_ -> E.equal (P.goR p_1__2__3_4_) (Just p_1_2__3__4_)
            ]
