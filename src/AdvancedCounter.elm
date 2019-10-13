module AdvancedCounter exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (br, button, input, text)
import Html.Attributes exposing (placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias State =
    { userInput : String
    , currentResult : Float
    }


type alias Model =
    List State


type Msg
    = Calculate (Float -> Float -> Float)
    | UserInput String
    | Undo


init : Model
init =
    [ { userInput = ""
      , currentResult = 0
      }
    ]


update : Msg -> Model -> Model
update msg modelWithHistory =
    case modelWithHistory of
        current :: history ->
            case msg of
                Calculate f ->
                    let
                        newResult : Float
                        newResult =
                            Maybe.withDefault current.currentResult <| Maybe.map (f current.currentResult) <| String.toFloat current.userInput
                    in
                    if isNaN newResult || isInfinite newResult then
                        modelWithHistory

                    else
                        { current | currentResult = newResult } :: modelWithHistory

                UserInput maybeNumber ->
                    { current | userInput = maybeNumber } :: modelWithHistory

                Undo ->
                    if List.isEmpty history then
                        init

                    else
                        history

        [] ->
            init


view : Model -> Html.Html Msg
view modelWithHistory =
    case modelWithHistory of
        current :: history ->
            let
                visibility : Html.Attribute Msg
                visibility =
                    style "visibility" <|
                        if List.isEmpty history then
                            "hidden"

                        else
                            "visible"
            in
            Html.div []
                [ text <| String.fromFloat current.currentResult
                , br [] []
                , button [ onClick <| Calculate (+) ] [ text "+" ]
                , button [ onClick <| Calculate (-) ] [ text "-" ]
                , button [ onClick <| Calculate (*) ] [ text "*" ]
                , button [ onClick <| Calculate (/) ] [ text "/" ]
                , br [] []
                , input [ onInput UserInput, value current.userInput, placeholder "0", type_ "number" ] []
                , br [ visibility ] []
                , button [ onClick Undo, visibility ] [ text <| "Undo last action (" ++ (String.fromInt <| List.length history) ++ " actions left)" ]
                ]

        [] ->
            Html.text "History was deleted (this should never happen) - fix update"
