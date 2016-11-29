module Examples.Undo.Partial exposing (..)

import Pivot as P exposing (Pivot)


type alias Counter1Model =
    Pivot Int


type alias Model =
    { counter1 : Counter1Model
    , counter2 : Int
    }


init : Model
init =
    { counter1 = P.singleton 0
    , counter2 = 0
    }


type Msg
    = Counter1 Counter1Msg
    | Counter2


update : Msg -> Model -> Model
update msg model =
    case msg of
        Counter1 counter1Msg ->
            { model
                | counter1 =
                    model.counter1
                        |> counter1Update counter1Msg
            }

        Counter2 ->
            { model
                | counter2 =
                    model.counter2 + 1
            }


type Counter1Msg
    = Inc
    | Undo
    | Redo


counter1Update : Counter1Msg -> Counter1Model -> Counter1Model
counter1Update counter1Msg counter1 =
    case counter1Msg of
        Inc ->
            let
                next =
                    P.getC counter1 + 1
            in
                counter1
                    |> P.addGoR next

        Undo ->
            counter1
                |> P.withRollback P.goL

        Redo ->
            counter1
                |> P.withRollback P.goR
