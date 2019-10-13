module HelloWorld exposing (view)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes as Attributes


main : Program () () msg
main =
    Browser.sandbox
        { init = ()
        , update = \_ x -> x
        , view = always view
        }


view : Html msg
view =
    div [ Attributes.style "background-color" "lightgreen" ] [ text "Hello World!" ]
