module Main exposing (main)

import Browser
import Html exposing (Html, button, text)
import Html.Events as Events


main : Program () Model Msg
main =
    Browser.sandbox
        { init = 0
        , update = update
        , view = view
        }


type alias Model =
    Int


type Msg
    = Decrement
    | Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Decrement ->
            model - 1

        Increment ->
            model + 1


view : Model -> Html Msg
view model =
    Html.div []
        [ button [ Events.onClick Decrement ] [ text "-" ]
        , text <| String.fromInt model
        , button [ Events.onClick Increment ] [ text "+" ]
        ]
