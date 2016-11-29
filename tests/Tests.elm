module Tests exposing (..)

import Debug exposing (log)
import Test exposing (..)
import Expect as Ex exposing (Expectation)
import Fuzz as Fz exposing (Fuzzer)
import String
import Pivot.Types as T
import Pivot exposing (..)
import Pivot.Utilities exposing (assertList)


all : Test
all =
    describe "Testing Pivot"
        [ utilities
        , create
        , get
        , position
        , modify
        ]


toPivot : List a -> a -> List a -> Pivot a
toPivot l c r =
    T.Pivot c ( l, r )


fuzz_ : Fuzzer a -> String -> (List a -> a -> List a -> Expectation) -> Test
fuzz_ fz =
    fuzz3 (Fz.list fz) fz (Fz.list fz)


equalIff : Bool -> a -> a -> Expectation
equalIff should =
    if should then
        Ex.equal
    else
        Ex.notEqual


iff =
    flip equalIff



--
-- onPivotData : (List a -> a -> List a -> Pivot a -> Expectation) -> List a -> a -> List a -> Expectation
-- onPivotData f l c r =
--   toPivot l c r |> f l c r
--


utilities : Test
utilities =
    describe "Utilities"
        [ fuzz_ Fz.char "reverse complies with List.reverse" <|
            \l c r ->
                Ex.equal (toPivot l c r |> reverse |> getA) (toPivot l c r |> getA |> List.reverse)
        , fuzz_ Fz.char "mirror turns left functions into right functions" <|
            \l c r ->
                toPivot l c r
                    |> mirror (mapL <| always 'A')
                    |> getR
                    |> Ex.equal (flip List.map r <| always 'A')
        , fuzz_ Fz.char "mirrorM turns leftM functions into rightM functions" <|
            \l c r ->
                toPivot l c r
                    |> mirrorM goL
                    |> Ex.equal
                        (case r of
                            hd :: tl ->
                                toPivot (c :: l) hd tl
                                    |> Just

                            [] ->
                                Nothing
                        )
        , fuzz_ (Fz.maybe Fz.unit) "assert agrees with assertList" <|
            \l c r ->
                Ex.equal (toPivot l c r |> assert |> Maybe.map getA) (toPivot l c r |> getA |> assertList)
        , fuzz_ (Fz.map Just Fz.unit) "assert pushes `Just` out when all values are `Just`s" <|
            \l c r ->
                Ex.equal (toPivot l c r |> assert |> Maybe.map getA) (toPivot l c r |> getA |> assertList)
        ]


create : Test
create =
    describe "Create"
        [ fuzz (Fz.list Fz.unit) "fromList fails iff list is empty" <|
            \list ->
                fromList list
                    |> iff Nothing (List.length list == 0)
        , fuzz (Fz.list Fz.unit) "fromCons won't have left" <|
            \list ->
                case list of
                    hd :: tl ->
                        fromCons hd tl
                            |> getL
                            |> Ex.equal []

                    [] ->
                        Ex.pass
        , test "singleton >> lengthA == always 1" <|
            \_ ->
                singleton ()
                    |> lengthA
                    |> Ex.equal 1
        ]


get : Test
get =
    describe "Get"
        [ fuzz_ Fz.char "getC should get center" <|
            \l c r ->
                toPivot l c r
                    |> getC
                    |> Ex.equal c
        , fuzz_ Fz.int "getL should get left" <|
            \l c r ->
                toPivot l c r
                    |> getL
                    |> Ex.equal (List.reverse l)
        , fuzz_ Fz.string "getR should get right" <|
            \l c r ->
                toPivot l c r
                    |> getR
                    |> Ex.equal r
        , fuzz_ Fz.char "getA == \\p -> getL p ++ [getC p] ++ getR p" <|
            \l c r ->
                Ex.equal (toPivot l c r |> \p -> getL p ++ [ getC p ] ++ getR p) (toPivot l c r |> getA)
        , fuzz_ Fz.float "hasL gives False iff no left" <|
            \l c r ->
                toPivot l c r
                    |> hasL
                    |> iff False (List.length l == 0)
        , fuzz_ Fz.unit "hasR gives False iff no right" <|
            \l c r ->
                toPivot l c r
                    |> hasR
                    |> iff False (List.length r == 0)
        ]


position : Test
position =
    describe "Position"
        [ fuzz_ Fz.char "goR |> Maybe.map getR == getR >> List.tail" <|
            \l c r ->
                Ex.equal (toPivot l c r |> goR |> Maybe.map getR) (toPivot l c r |> getR >> List.tail)
        , fuzz_ Fz.char "goR |> Maybe.andThen goR == goBy 2" <|
            \l c r ->
                Ex.equal (toPivot l c r |> goR |> Maybe.andThen goR) (toPivot l c r |> goBy 2)
        , fuzz_ Fz.char "goR |> Maybe.andThen goL == goBy 0" <|
            \l c r ->
                Ex.equal (toPivot l c r |> goR |> Maybe.andThen goL) (toPivot l c r |> goBy 0)
        , fuzz_ Fz.char "goToStart >> Just == goTo 0" <|
            \l c r ->
                Ex.equal (toPivot l c r |> goToStart >> Just) (toPivot l c r |> goTo 0)
        , fuzz_ Fz.char "goToStart >> getL == []" <|
            \l c r ->
                (toPivot l c r |> goToStart >> getL)
                    |> Ex.equal []
        , fuzz_ Fz.char "goToStart >> getR >> Just == getA >> List.tail" <|
            \l c r ->
                Ex.equal (toPivot l c r |> goToStart >> getR >> Just) (toPivot l c r |> getA >> List.tail)
        ]


modify : Test
modify =
    describe "Sort"
        [ fuzz_ Fz.char "sort >> getA == getA >> List.sort" <|
            \l c r ->
                Ex.equal (toPivot l c r |> sort >> getA) (toPivot l c r |> getA >> List.sort)
        , fuzz_ Fz.char "getC == sort >> getC" <|
            \l c r ->
                Ex.equal (toPivot l c r |> sort >> getC) (toPivot l c r |> getC)
        ]
