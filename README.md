# Pivot, the data structure

Pivot upgrades a list to a list with a center, left and right. You can think of it as a list with a cursor pointing at some value inside it, or better yet, a list with a location acting as a pivot. This structure makes a lot of sense when you want functionality such as

* scrolling through a list, e.g. a playlist,
* undo and redo, where the left holds previous states, and the right holds future states (after you did some undos),
* control focus of form elements (although you'd need to be clever about it, to account for when no element is in focus),
* and many more.

## What if my list is empty?

Alright, slight lie earlier. Pivot actually upgrades a cons list (a non-empty list).
You can try to upgrade a list, but it may fail. Explicitly, consider the
following functions from this library,

```elm
from : List a -> Maybe (Pivot a)
```

```elm
fromCons : a -> List a -> Pivot a
```

# Examples

## Browsing

A pivot is perfect for implementing a collection browser (e.g. of a music playlist).

```elm
import Pivot as P exposing (Pivot)

type alias Model = Maybe (Pivot Artist)

type alias Artist = String

-- We start without any artists.
init : Model
init =
  Nothing

type Msg
  = Next
  | Previous
  | Remove
  | Add Artist
  | MoveItemUp
  | MoveItemDown
  -- etc...

update : Msg -> Model -> Model
update msg model =
  case msg of
    Next ->
      model
      -- Attempt to go forward, rollback if can't.
      |> Maybe.map (P.withRollback P.goR)
    Previous ->
      model
      -- Attempt to go back, rollback if can't.
      |> Maybe.map (P.withRollback P.goL)
    Remove ->
      -- Attempt to remove and go backwards.
      -- Will fail if there is no backwards to go to.
      case model |> Maybe.andThen P.removeGoL of
        Just collection ->
          Just collection
        Nothing ->
          -- Attempt to remove and go forward otherwise.
          -- Upon failure, there is nowhere to go, so Nothing is OK.
          model |> Maybe.andThen P.removeGoR
    Add item ->
      model
      -- Attempt to append to an existing collection.
      |> Maybe.map (P.appendGoR item)
      -- Start from scratch otherwise.
      |> Maybe.withDefault (P.singleton item)
      -- Wrap back into a `Maybe`.
      |> Just
    MoveItemUp ->
      model
      -- Attempt to move item forward.
      -- If it can't (no item in front), do nothing.
      |> Maybe.map (P.withRollback P.switchR)
    MoveItemDown ->
      model
      -- Attempt to move item backwards.
      -- If it can't (no item behind), do nothing.
      |> Maybe.map (P.withRollback P.switchL)
    -- etc...
```

## Focus

Can you imagine how this library can be used to hold a bunch of input fields' values, with one of the fields in focus? Thinking about the fields as a collection, it is exactly like the browser from before.

## Undo

This library can be used to add an undo-redo functionality to your app. Consider an simple app like this:

```elm
type alias Model =
  { counter1 : Int
  , counter2 : Int
  }

init : Model
init =
  { counter1 = 0
  , counter2 = 0
  }

type Msg
  = NoOp
  | Inc1
  | Inc2

update : Msg -> Model -> Model
update msg model =
  case msg of
    Inc1 ->
      { model | counter1 = model.counter1 + 1 }
    Inc2 ->
      { model | counter2 = model.counter2 + 1 }
    NoOp ->
      model
```

We decide that we want the user to be able to undo changes to the counters. To accomplish this, we append each new version of the model to a pivot instead of modifying it in place. This way we retain previous models, and can simply browse between them back and forth.

```elm
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
type alias Model = Pivot Counters

init : Model
init =
  initRec
  |> P.singleton

type Msg
  = New RecMsg
  | Undo
  | Redo

update : Msg -> Model -> Model
update msg model =
  case msg of
    Undo ->
      model
      -- Try to undo.
      -- If there's no previous state, do nothing.
      |> P.withRollback P.goL
    Redo ->
      model
      -- Try to undo.
      -- If there's no next state, do nothing.
      |> P.withRollback P.goR
    New msgRec ->
      let
        next =
          -- Getting the current state.
          P.getC model
          -- Updating from it using the message.
          |> updateRec msgRec
      in
        model
        -- Adding the next state (instead of replacing the current one).
        |> P.appendGoR next
```

So we have undo, but we're recording every single state of the model. What if we only want part of the model to be undoable, say just the first counter? Below is just one possible implementation. I'll let you to try to make sense of it yourself.

```elm
import Pivot as P exposing (Pivot)

type alias Counter1Model = Pivot Int

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
        |> P.appendGoR next
    Undo ->
      counter1
      |> P.withRollback P.goL
    Redo ->
      counter1
      |> P.withRollback P.goR
```

# Alternatives

There are a few alternatives to this package.

* The [jjant/elm-comonad-zipper](http://package.elm-lang.org/packages/latest/jjant/elm-comonad-zipper) and [wernerdegroot/listzipper](http://package.elm-lang.org/packages/latest/wernerdegroot/listzipper) packages provide essentially the same structure but less methods to manipulate and process it.
* The [miyamoen/tree-with-zipper](http://package.elm-lang.org/packages/latest/miyamoen/tree-with-zipper) and [zwilias/elm-rosetree](http://package.elm-lang.org/packages/latest/zwilias/elm-rosetree) packages provide a more expressive tree-like structure which complicates its usage.
