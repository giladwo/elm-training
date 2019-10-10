module Main exposing (main)

import Browser
import Element
import Element.Events as Events
import Element.Input as Input


main : Program () Model Msg
main =
    Browser.sandbox
        { init = 0
        , update = update
        , view = Element.layout (styleByGroup GlobalStyle) << view
        }


type StyleGroup
    = GlobalStyle
    | ButtonStyle
    | TextStyle


styleByGroup : StyleGroup -> List (Element.Attribute Msg)
styleByGroup group =
    case group of
        GlobalStyle ->
            []

        ButtonStyle ->
            []

        TextStyle ->
            []


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


view : Model -> Element.Element Msg
view model =
    Element.column []
        [ Input.button (styleByGroup ButtonStyle)
            { onPress = Just Decrement
            , label = Element.text "-"
            }
        , Element.text <| String.fromInt model
        , Input.button (styleByGroup ButtonStyle)
            { onPress = Just Increment
            , label = Element.text "+"
            }
        ]
