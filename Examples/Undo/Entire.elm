module Examples.Undo.Entire exposing (..)

import Pivot as P exposing (Pivot)


-- This was the model before.


type alias Counters =
    { counter1 : Int
    , counter2 : Int
    }


initRec : Counters
initRec =
    { counter1 = 0
    , counter2 = 0
    }


type RecMsg
    = NoOp
    | Inc1
    | Inc2



-- This was the update function before.


updateRec : RecMsg -> Counters -> Counters
updateRec msgRec rec =
    case msgRec of
        Inc1 ->
            { rec | counter1 = rec.counter1 + 1 }

        Inc2 ->
            { rec | counter2 = rec.counter2 + 1 }

        NoOp ->
            rec



-- Now we wrap it all in a pivot.


type alias Model =
    Pivot Counters


init : Model
init =
    initRec
        |> P.pure


type Msg
    = New RecMsg
    | Undo
    | Redo


update : Msg -> Model -> Model
update msg model =
    case msg of
        Undo ->
            model
                |> P.withRollback P.goL

        Redo ->
            model
                |> P.withRollback P.goR

        New msgRec ->
            let
                -- Creating the next state.
                next =
                    P.getC model
                        |> updateRec msgRec
            in
                -- Adding the next state.
                model
                    |> P.addGoR next
