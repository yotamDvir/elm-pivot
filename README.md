# Pivot, the data structure

Pivot upgrades a list to a list with a center, left and right. You can think
of it as a list with a cursor pointing at some value inside it, or better yet,
a list with a location acting as a pivot.
This structure makes a lot of sense when you want functionality such as

* scrolling through a list, e.g. a playlist,
* undo and redo, where the left holds previous states,
and the right holds future states (after you did some undos),
* control focus of form elements (although you'd need to be clever
about it, to account for when no element is in focus),

and many more.

## Examples

### Undo

Consider the following model and update:

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

We decide that we want the user to be able to undo changes to the counters.
We modify our model and update so that instead of replacing the model
with the next version, we add it to a pivot that contains all versions.

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
```

_Note: undoing here is trying to go left, but if it fails we rollback to
no doing anything, which makes sense if there is nowhere to go back to._

So we have undo, but we're recording every single state of the model.
What if we only want part of the model to be undoable,
say just the first counter?
Below is just one possible implementation.

```elm
import Pivot as P exposing (Pivot)

type alias Counter1Model = Pivot Int

type alias Model =
  { counter1 : Counter1Model
  , counter2 : Int
  }

init : Model
init =
  { counter1 = P.pure 0
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
```

### Browsing

A pivot is perfect for browsing some collection.

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
      -- Attempt to go forward, rollback if can't.
      model
      |> Maybe.map (P.withRollback P.goR)
    Previous ->
      -- Attempt to go back, rollback if can't.
      model
      |> Maybe.map (P.withRollback P.goL)
    Remove ->
      case model `Maybe.andThen` P.removeGoL of -- Attempt to go back after.
        Just collection ->
          Just collection
        Nothing ->
          model `Maybe.andThen` P.removeGoR -- Attempt to go forward otherwise.
    Add item ->
      model
      |> Maybe.map (P.addGoR item) -- Attempt to add to an existing collection.
      |> Maybe.withDefault (P.pure item) -- Start from scratch otherwise.
      |> Just -- Make the collection a `Maybe` again.
    MoveItemUp ->
      -- Attempt to move item up, rollback if can't.
      model
      |> Maybe.map (P.withRollback P.switchR)
    MoveItemDown ->
      -- Attempt to move item down, rollback if can't.
      model
      |> Maybe.map (P.withRollback P.switchL)
    -- etc...
```

### Focus

Can you imagine how this library can be used to hold a bunch of
input fields' values, with one of the fields in focus?

## Alternatives

* The [undo-redo](http://package.elm-lang.org/packages/elm-community/undo-redo)
library holds all states in a Pivot-like structure and
lets you undo and redo through them.
It is actually very similar to this library, but exposes less methods,
and is semantically odd to use when doing anything that isn't undo/redo.
* The [elm-multiway-tree-zipper](http://package.elm-lang.org/packages/tomjkidd/elm-multiway-tree-zipper/)
library is much closer to the [zipper](http://learnyouahaskell.com/zippers) from
Haskell, and provides a much more extensive structure, but exposes much
less methods, and is unnecessarily complicated if you are dealing with
a structure that resembles a list and not a tree.
* The [listzipper](http://package.elm-lang.org/packages/wernerdegroot/listzipper/)
library exposes the same structure, but has only a handful of methods and
at the time of writing is not up to date with the most recent version of Elm.

## What if my list is empty?

Well, we lied before. Pivot actually upgrades a cons list (a non-empty list).
You can try to upgrade a list, but it may fail. Explicitly, consider the
following functions from this library,

```elm
from : List a -> Maybe (Pivot a)
```

```elm
fromCons : a -> List a -> Pivot a
```

## What's next

### Generalizations

Right now the center must have the same type as the members of the sides.
One possible generalization is to let the center have any arbitrary type,
but then the pivot will need to be equipped with transformation functions
for moving the member from the sides to the center and vice-verse.

For example, you may want to use a pivot to observe codons inside genetic
code, but a codon is a 3-tuple of nucleotides, while you may
want to move about the genetic code a single nucleotide at a time.

```elm
-- Reading genetic code, with a generalized pivot.
type Nucleotide = A | T | G | C
type alias Codon = (Nucleotide, Nucleotide, Nucleotide)
fromL n (n1, n2, n3) = (n, n1, n2)
toR (n1, n2, n3) = n3
type alias GeneticCode = GeneralizedPivot fromL toR Codon Nucleotide
```

If this or any other generalization are wanted,
please post an issue in the repository.
Even better, help create it!

### More methods

If you feel this library is lacking a method you think would rock,
please post an issue in the repository.
