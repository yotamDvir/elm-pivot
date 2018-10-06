module Pivot.Types exposing (Left, Pivot(..), Right, Sides)


type Pivot a
    = Pivot a (Sides a)


type alias Sides a =
    ( Left a, Right a )


type alias Left a =
    List a


type alias Right a =
    List a
