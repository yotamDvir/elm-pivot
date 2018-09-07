module Create exposing (..)

import Common.Units exposing (..)
import Expect as E
import Fuzz as F
import Pivot as P
import Pivot.Types exposing (Pivot(..))
import Test exposing (Test, describe, fuzz, fuzz2, fuzz3, only, skip, test)


fromList : Test
fromList =
    describe "fromList" <|
        [ test "fromList [] == Nothing" <|
            \_ -> E.equal (P.fromList []) Nothing
        , test "fromList [1, 2, 3, 4] == [*1* 2 3 4]" <|
            \_ -> E.equal (P.fromList [ 1, 2, 3, 4 ]) (Just p__1__2_3_4_)
        ]


fromCons : Test
fromCons =
    describe "fromCons" <|
        [ test "fromList [1, 2, 3, 4] == [*1* 2 3 4]" <|
            \_ -> E.equal (P.fromCons 1 [ 2, 3, 4 ]) p__1__2_3_4_
        , fuzz2 F.string (F.list F.string) "Just (fromCons h t) == fromList (h :: t)" <|
            \h t -> E.equal (Just <| P.fromCons h t) (P.fromList (h :: t))
        ]


singleton : Test
singleton =
    describe "singleton" <|
        [ test "singleton 3 == [*3*]" <|
            \_ -> E.equal (P.singleton 3) (Pivot 3 ( [], [] ))
        , fuzz F.string "singleton x == fromCons x []" <|
            \x -> E.equal (P.singleton x) (P.fromCons x [])
        ]
