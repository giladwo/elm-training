module AdvancedCounter exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (br, button, input, text)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { userInput : String
    , currentResult : Float
    }


type Msg
    = Calculate (Float -> Float -> Float)
    | UserInput String


init : Model
init =
    { userInput = ""
    , currentResult = 0
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Calculate f ->
            let
                newResult : Float
                newResult =
                    Maybe.withDefault model.currentResult <| Maybe.map (f model.currentResult) <| String.toFloat model.userInput
            in
            if isNaN newResult || isInfinite newResult then
                model

            else
                { model | currentResult = newResult }

        UserInput maybeNumber ->
            { model | userInput = maybeNumber }


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ text <| String.fromFloat model.currentResult
        , br [] []
        , button [ onClick <| Calculate (+) ] [ text "+" ]
        , button [ onClick <| Calculate (-) ] [ text "-" ]
        , button [ onClick <| Calculate (*) ] [ text "*" ]
        , button [ onClick <| Calculate (/) ] [ text "/" ]
        , br [] []
        , input [ onInput UserInput, value model.userInput, placeholder "0", type_ "number" ] []
        ]
