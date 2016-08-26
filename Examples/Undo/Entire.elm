module Examples.Undo.Entire exposing (..)

import Pivot as P exposing (Pivot)

type alias Counters =
  { counter1 : Int
  , counter2 : Int
  }

init : Pivot Counters
init =
  initRec
  |> P.pure

type Msg
  = New RecMsg
  | Undo
  | Redo

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
        next =
          model
          |> P.getC
          |> updateRec msgRec
      in
        model
        |> P.addGoR next

-- This was the model before.
initRec =
  { counter1 = 0
  , counter2 = 0
  }

type RecMsg
  = NoOp
  | Inc1
  | Inc2

-- This was the update function before.
updateRec msgRec rec =
  case msgRec of
    Inc1 ->
      { rec | counter1 = rec.counter1 + 1 }
    Inc2 ->
      { rec | counter2 = rec.counter2 + 1 }
    NoOp ->
      rec
