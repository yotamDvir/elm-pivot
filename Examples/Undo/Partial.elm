module Examples.Undo.Partial exposing (..)

import Pivot as P exposing (Pivot)

type alias Counters =
  { counter1 : Pivot Int
  , counter2 : Int
  }

init : Counters
init =
  { counter1 = P.pure 0
  , counter2 = 0
  }

type Msg
  = Counter1 Counter1Msg
  | Counter2

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
        model.counter2
        |> (+) 1
      }

type Counter1Msg
  = Inc
  | Undo
  | Redo

counter1Update counter1Msg counter1 =
  case counter1Msg of
    Inc ->
      let
        next =
          counter1
          |> P.getC
          |> (+) 1
      in
        counter1
        |> P.addGoR next
    Undo ->
      counter1
      |> P.withRollback P.goL
    Redo ->
      counter1
      |> P.withRollback P.goR
