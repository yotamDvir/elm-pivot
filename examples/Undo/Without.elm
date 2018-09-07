module Examples.Undo.Without exposing (..)


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
