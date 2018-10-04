module Pivot.Utilities
    exposing
        ( assert
        , mirror
        , mirrorM
        , reverse
        , reversePrependList
        , withRollback
        )

import Pivot.Types exposing (..)


reverse : Pivot a -> Pivot a
reverse (Pivot c ( l, r )) =
    Pivot c ( r, l )


mirror : (Pivot a -> Pivot b) -> Pivot a -> Pivot b
mirror f =
    reverse >> f >> reverse


mirrorM : (Pivot a -> Maybe (Pivot b)) -> Pivot a -> Maybe (Pivot b)
mirrorM f =
    reverse >> f >> Maybe.map reverse


assertList : List (Maybe a) -> Maybe (List a)
assertList =
    let
        maybeAppend maybeVal maybeList =
            case ( maybeVal, maybeList ) of
                ( Just val, Just list ) ->
                    Just (val :: list)

                _ ->
                    Nothing
    in
    Just [] |> List.foldr maybeAppend


assert : Pivot (Maybe a) -> Maybe (Pivot a)
assert (Pivot mc ( ml, mr )) =
    case ( mc, ( assertList ml, assertList mr ) ) of
        ( Just c, ( Just l, Just r ) ) ->
            Just (Pivot c ( l, r ))

        _ ->
            Nothing


withRollback : (a -> Maybe a) -> a -> a
withRollback f x =
    f x |> Maybe.withDefault x


reversePrependList : List a -> List a -> List a
reversePrependList l r =
    case l of
        x :: xs ->
            reversePrependList xs (x :: r)

        _ ->
            r
