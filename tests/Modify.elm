module Modify exposing (..)

import Common.Units as Fuzz exposing (pivot)
import Expect
import Fuzz
import Pivot
import Test exposing (Test, describe)


setL : Test
setL =
    describe "setL"
        [ Test.fuzz (Fuzz.pivot Fuzz.int) "setL (getL a) a == a" <|
            \pivot ->
                Pivot.setL (Pivot.getL pivot) pivot
                    |> Expect.equal pivot
        , Test.fuzz2 (Fuzz.list Fuzz.int) (Fuzz.pivot Fuzz.int) "getL (setL l a) == l" <|
            \list pivot ->
                Pivot.getL (Pivot.setL list pivot)
                    |> Expect.equal list
        ]


setR : Test
setR =
    describe "setR"
        [ Test.fuzz (Fuzz.pivot Fuzz.int) "setR (getR a) == a" <|
            \pivot ->
                Pivot.setR (Pivot.getR pivot) pivot
                    |> Expect.equal pivot
        , Test.fuzz2 (Fuzz.list Fuzz.int) (Fuzz.pivot Fuzz.int) "getR (setR l a) == l" <|
            \list pivot ->
                Pivot.getR (Pivot.setR list pivot)
                    |> Expect.equal list
        , Test.fuzz3 Fuzz.int (Fuzz.list Fuzz.int) (Fuzz.pivot Fuzz.int) "goR (setR (x :: xs) a) == Just (setR xs (appendGoR x a))" <|
            \x xs pivot ->
                Pivot.goR (Pivot.setR (x :: xs) pivot)
                    |> Expect.equal (Just (Pivot.setR xs (Pivot.appendGoR x pivot)))
        ]
