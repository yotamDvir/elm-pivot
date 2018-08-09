module Examples.Browse.Maybe exposing (..)

import Pivot as P exposing (Pivot)


type alias Model =
    Maybe (Pivot Artist)


type alias Artist =
    String



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
            case model |> Maybe.andThen P.removeGoL of
                -- Attempt to go back after.
                Just collection ->
                    Just collection

                Nothing ->
                    model |> Maybe.andThen P.removeGoR

        -- Attempt to go forward otherwise.
        Add item ->
            model
                |> Maybe.map (P.addGoR item)
                -- Attempt to add to an existing collection.
                |> Maybe.withDefault (P.singleton item)
                -- Start from scratch otherwise.
                |> Just

        -- Make the collection a `Maybe` again.
        MoveItemUp ->
            -- Attempt to move item up, rollback if can't.
            model
                |> Maybe.map (P.withRollback P.switchR)

        MoveItemDown ->
            -- Attempt to move item down, rollback if can't.
            model
                |> Maybe.map (P.withRollback P.switchL)



-- etc...
