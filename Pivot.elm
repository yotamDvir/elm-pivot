module Pivot exposing (..)

{-| A pivot is a list upgraded with a center and sides. However, a pivot
can never be empty, so it is better to think of it an upgraded cons list.

In this library, we suffix functions with letters to denote their context,
as follows.

* The __C__enter
* Both __S__ides
* The __L__eft side
* The __R__ight side
* __A__ll the members

This way you can guess a function's name easily.
See the different `map*` functions.

For example, `getL` gets the left side of a pivot.

# Type
@docs Pivot

# To & Fro
So you want to use a pivot? Better know how to create one, and get stuff back!

## Create
@docs fromList, fromCons, singleton

## Get
@docs getC, getL, getR, getA, hasL, hasR

# Movement
Handle the position of the center.
These functions do not mutate the underlying list.
That is, if you apply functions from here and then apply `getA`,
you'd get the same thing you would by applying `getA` beforehand.

## Position
@docs lengthL, lengthR, lengthA

## Momentum
@docs goR, goL, goBy, goTo, goToStart, goToEnd

## Find
@docs firstWith, lastWith, findR, findL, findCR, findCL

# Modify
Now we start seeing functions that can actually change the underlying list.

## Set
@docs setC, setL, setR

## Add
@docs addL, addR, addGoL, addGoR

## Remove
Removing is not guaranteed to work,
for the simple reason that a pivot cannot be empty.
@docs removeGoL, removeGoR

## Switch
Switch places with other members.
@docs switchL, switchR

## Sort
@docs sort, sortWith

# Maps
Lists can be mapped over, and so can pivots.
However, since a pivot is made up of three distinct objects at any time,
it makes sense that you may want to apply different transformations to
the different objects.

## Maps
@docs mapCLR, mapCRL, mapCS, mapA

## Constraint Maps
If you want to map only over some of the pivot,
then you must retain the type.
@docs mapC, mapS, mapL, mapR

## As a whole
Some `List a -> List a` functions cannot be made from `a -> a` functions.
This is why these maps may be of importance.
Just replace `map*` with `mapWhole*` to use functions on whole lists instead of values.

@docs mapWholeCLR, mapWholeCRL, mapWholeCS, mapWholeS, mapWholeL, mapWholeR

## Special
@docs zip, apply

# Utilities
@docs reverse, mirror, mirrorM, assert, withRollback
-}

import Pivot.Types
import Pivot.Create as Create
import Pivot.Get as Get
import Pivot.Find as Find
import Pivot.Position as Position
import Pivot.Modify as Modify
import Pivot.Map as Map
import Pivot.Utilities as Utilities


{-| Pivot is an opaque data type.
-}
type alias Pivot a =
    Pivot.Types.Pivot a


{-| Make a pivot from a list with empty left side.

_Fails if and only if the list given is empty._

    fromList [] == Nothing
-}
fromList : List a -> Maybe (Pivot a)
fromList =
    Create.fromList


{-| Like `fromList`, but by specifying the center explicitly, it cannot fail.

    getC (fromCons "well" ["hello", "world"]) == "well"
    getL (fromCons "well" ["hello", "world"]) == []
    getR (fromCons "well" ["hello", "world"]) == ["hello", "world"]
    Just (fromCons 1 [2..4]) == fromList [1..4]
-}
fromCons : a -> List a -> Pivot a
fromCons =
    Create.fromCons


{-| Like `fromCons`, but without the list. That is, we specify only the center.

    singleton == flip fromCons []
-}
singleton : a -> Pivot a
singleton =
    Create.singleton


{-| Get the center member.

    singleton >> getC == identity
-}
getC : Pivot a -> a
getC =
    Get.getC


{-| Get the left side list.
-}
getL : Pivot a -> List a
getL =
    Get.getL


{-| Get the right side list.
-}
getR : Pivot a -> List a
getR =
    Get.getR


{-| Make the pivot into a list.
-}
getA : Pivot a -> List a
getA =
    Get.getA


{-| Check if the left side is not empty.
-}
hasL : Pivot a -> Bool
hasL =
    Get.hasL


{-| Check if the right side is not empty.
-}
hasR : Pivot a -> Bool
hasR =
    Get.hasR


{-| Find the first member of a pivot satisfying some predicate.

_Fails if and only if there are no such members._
-}
firstWith : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
firstWith =
    Find.firstWith


{-| Find the last member of a pivot satisfying some predicate.

_Fails if and only if there are no such members._
-}
lastWith : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
lastWith =
    Find.lastWith


{-| Find the first member to the center's right satisfying some predicate.

_Fails if and only if there are no such members._

    findR ((==) 3) (fromCons 1 [2..4]) == (singleton 3 |> setL [1, 2] |> setR [4])
-}
findR : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findR =
    Find.findR


{-| Find the first member to the center's left satisfying some predicate.

_Fails if and only if there are no such members._
-}
findL : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findL =
    Find.findL


{-| Like `findR`, but checks the center first as well.

_Fails if and only if there are no such members._

    firstWith == \pred -> goToStart >> findCR pred
-}
findCR : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findCR =
    Find.findCR


{-| Like `findL`, but checks the center first as well.

_Fails if and only if there are no such members._
-}
findCL : (a -> Bool) -> Pivot a -> Maybe (Pivot a)
findCL =
    Find.findCL


{-| Move one step right.

_Fails if and only if the right side is empty._

Tip: You can avoid the failure using `withRollback`,
and instead have a possible no-op. See __Utilities__.

    fromCons 1 [2..4] |> goR /= Nothing
-}
goR : Pivot a -> Maybe (Pivot a)
goR =
    Position.goR


{-| Move one step left.

_Fails if and only if the left side is empty._

    goL (fromCons 1 [2..4]) == Nothing
    withRollback goL (fromCons 1 [2..4]) == fromCons 1 [2..4]
-}
goL : Pivot a -> Maybe (Pivot a)
goL =
    Position.goL


{-| Move right by some number of steps. Negative number moves left instead.

_Fails if and only if the movement goes out of bounds._
-}
goBy : Int -> Pivot a -> Maybe (Pivot a)
goBy =
    Position.goBy


{-| Go to a specific position from the left. Starts with 0.

_Fails if and only if the position given doesn't exist._
-}
goTo : Int -> Pivot a -> Maybe (Pivot a)
goTo =
    Position.goTo


{-| Go to starting position.

    goToStart >> lengthL == 0
-}
goToStart : Pivot a -> Pivot a
goToStart =
    Position.goToStart


{-| Go to starting position.

    goToEnd >> lengthR == 0
-}
goToEnd : Pivot a -> Pivot a
goToEnd =
    Position.goToEnd


{-| Position from the left side. Starts with 0.
-}
lengthL : Pivot a -> Int
lengthL =
    Position.lengthL


{-| Position from the right side. Starts with 0.
-}
lengthR : Pivot a -> Int
lengthR =
    Position.lengthR


{-| Length of the pivot.

    lengthA == \p -> lengthL p + 1 + lengthR p
-}
lengthA : Pivot a -> Int
lengthA =
    Position.lengthA


{-| Replace the center.
-}
setC : a -> Pivot a -> Pivot a
setC =
    Modify.setC


{-| Replace the left.
-}
setL : List a -> Pivot a -> Pivot a
setL =
    Modify.setL


{-| Replace the right.
-}
setR : List a -> Pivot a -> Pivot a
setR =
    Modify.setR


{-| Switch places with member nearest to the left

_Fails if and only if left side is empty_
-}
switchL : Pivot a -> Maybe (Pivot a)
switchL =
    Modify.switchL


{-| Switch places with member nearest to the right

_Fails if and only if right side is empty_
-}
switchR : Pivot a -> Maybe (Pivot a)
switchR =
    Modify.switchR


{-| Replace center with member nearest to the left.

_Fails if and only if left side is empty._
-}
removeGoL : Pivot a -> Maybe (Pivot a)
removeGoL =
    Modify.removeGoL


{-| Replace center with member nearest to the right.

_Fails if and only if right side is empty._
-}
removeGoR : Pivot a -> Maybe (Pivot a)
removeGoR =
    Modify.removeGoR


{-| Add a member to the left of the center
-}
addL : a -> Pivot a -> Pivot a
addL =
    Modify.addL


{-| Add a member to the right of the center
-}
addR : a -> Pivot a -> Pivot a
addR =
    Modify.addR


{-| Add a member to the left of the center and immediately move left.
We know that `addL >> goL` cannot really fail, but it still results in a
`Maybe` type. This avoids this issue.

    addGoL >> Just == addL >> goL
-}
addGoL : a -> Pivot a -> Pivot a
addGoL =
    Modify.addGoL


{-| Add a member to the right of the center and immediately move right.
-}
addGoR : a -> Pivot a -> Pivot a
addGoR =
    Modify.addGoR


{-| Sort a pivot while keeping the center as center.

It does not simply sort each side separately!

    sort >> getA == getA >> List.sort
    getC == sort >> getC
-}
sort : Pivot comparable -> Pivot comparable
sort =
    Modify.sort


{-| Like `sort`, but with a costum comparator.

    sort == sortWith compare
-}
sortWith : (a -> a -> Order) -> Pivot a -> Pivot a
sortWith =
    Modify.sortWith


{-| Provide functions that control what happens to the center,
the left members and the right member separately,
and get a function that acts on pivots.
-}
mapCLR : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCLR =
    Map.mapCLR


{-| Like `mapCLR`, but provide the function for the right before the left.
-}
mapCRL : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCRL =
    Map.mapCRL


{-| Like `mapCLR`, but you provide one function for both sides.
-}
mapCS : (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCS =
    Map.mapCS


{-| Like `mapCS`, but you provide one function for all members.
This is exactly like `List.map` for the underlying list.

    mapA ((==) 3) [1 *2* 3 4] == [False *False* True False]
-}
mapA : (a -> b) -> Pivot a -> Pivot b
mapA =
    Map.mapA


{-| Like `mapA`, but only the center is affected.
-}
mapC : (a -> a) -> Pivot a -> Pivot a
mapC =
    Map.mapC


{-| Like `mapA`, but only the left is affected.
-}
mapL : (a -> a) -> Pivot a -> Pivot a
mapL =
    Map.mapL


{-| Like `mapA`, but only the right is affected.
-}
mapR : (a -> a) -> Pivot a -> Pivot a
mapR =
    Map.mapR


{-| Like `mapA`, but the center is __not__ affected.
-}
mapS : (a -> a) -> Pivot a -> Pivot a
mapS =
    Map.mapS


{-| Like `mapWholeCLR`, but the functions for the left and right act on the
lists as a whole, and not on each member separately.
The lists are ordered from the center out.

    mapWholeCLR ((*) 3) (List.drop 1) (List.drop 1) [1 2 *3* 4 5] == [1 *9* 5]
-}
mapWholeCLR : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapWholeCLR =
    Map.mapWholeCLR


{-| See `mapWholeCLR`.
-}
mapWholeCRL : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapWholeCRL =
    Map.mapWholeCRL


{-| See `mapWholeCLR`.
-}
mapWholeCS : (a -> b) -> (List a -> List b) -> Pivot a -> Pivot b
mapWholeCS =
    Map.mapWholeCS


{-| See `mapWholeCLR`.
-}
mapWholeL : (List a -> List a) -> Pivot a -> Pivot a
mapWholeL =
    Map.mapWholeL


{-| See `mapWholeCLR`.
-}
mapWholeR : (List a -> List a) -> Pivot a -> Pivot a
mapWholeR =
    Map.mapWholeR


{-| See `mapWholeCLR`.
-}
mapWholeS : (List a -> List a) -> Pivot a -> Pivot a
mapWholeS =
    Map.mapWholeS


{-| Adds indices to the values.
Based internally on `List.indexedMap`.
-}
zip : Pivot a -> Pivot ( Int, a )
zip =
    Map.zip


{-| Apply functions in a pivot on values in another Pivot.
The center gets applied to the center,
and each side gets applied to each side.
But how does a list of functions get applied on a list of values?
Well, each function maps over the complete list of values,
and then all the lists created from these applications are concatinated.

    mapCLR onC onL onR == (singleton onC |> setL [ onL ] |> setR [ onR ] |> apply)
-}
apply : Pivot (a -> b) -> Pivot a -> Pivot b
apply =
    Map.apply


{-| Reverse a pivot, like a list. You could also think of it as mirroring
left and right.
-}
reverse : Pivot a -> Pivot a
reverse =
    Utilities.reverse


{-| Reverse a function's notion of left and right.
Used in many of this library's functions under the hood
-}
mirror : (Pivot a -> Pivot b) -> Pivot a -> Pivot b
mirror =
    Utilities.mirror


{-| Reverse a possibly-failing-function's notion of left and right.
Used in many of this library's functions under the hood
-}
mirrorM : (Pivot a -> Maybe (Pivot b)) -> Pivot a -> Maybe (Pivot b)
mirrorM =
    Utilities.mirrorM


{-| Takes a pivot full of possible values, and realizes it only if all
the values are real. That is, if all the values are `Just a`, then we get
`Just (Pivot a)`. Otherwise, we get `Nothing`.
This is great for composing with the different map functions.
For example, you could define

    mapAM : (a -> Maybe b) -> Pivot a -> Maybe (Pivot b)
    mapAM f = mapA f >> assert
-}
assert : Pivot (Maybe a) -> Maybe (Pivot a)
assert =
    Utilities.assert


{-| Replace a possibly-failing-function with a possibly-does-nothing-function.
For example, if you try to `goR` a pivot,
you may fail since there is nothing to the right.
But if you `withRollback goR` a pivot,
the worst that could happen is that nothing happens.

Use it, don't abuse it. That is, only use it when it makes sense to ignore
a failure, or when you are __certain__ a possibly-failing-function cannot
really fail. For example,

    addGoR == addR >> withRollback goR

It might be useful to define infix operators as such.

    (!>) = flip withRollback
    infixl 0 !>

    (<!) = withRollback
    infixr 0 <!

    goR <! pvt == withRollback goR pvt
-}
withRollback : (a -> Maybe a) -> a -> a
withRollback =
    Utilities.withRollback
