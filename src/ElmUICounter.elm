module ElmUICounter exposing (Model, Msg, init, update, view)

import Browser
import Element
import Element.Events as Events
import Element.Input as Input
import Html exposing (Html)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


init : Model
init =
    0


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


viewInner : Model -> Element.Element Msg
viewInner model =
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


view : Model -> Html Msg
view =
    Element.layout (styleByGroup GlobalStyle) << viewInner
