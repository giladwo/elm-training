module HelloWorld exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes as Attributes


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


init : Model
init =
    ()


type alias Model =
    ()


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> Html Msg
view model =
    div [ Attributes.style "background-color" "lightgreen" ] [ text "Hello World!" ]
