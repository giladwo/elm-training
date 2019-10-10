module Main exposing (Model, Msg(..), main, update, view)

import Browser
import Counter
import ElmUICounter
import HelloWorld
import Html


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { counterModel : Counter.Model
    , elmUiCounterModel : ElmUICounter.Model
    , helloWorldModel : HelloWorld.Model
    }


type Msg
    = NoOp
    | CounterMsg Counter.Msg
    | ElmUICounterMsg ElmUICounter.Msg
    | HelloWorldMsg HelloWorld.Msg


init : Model
init =
    { counterModel = Counter.init
    , elmUiCounterModel = ElmUICounter.init
    , helloWorldModel = HelloWorld.init
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        CounterMsg subMsg ->
            { model | counterModel = Counter.update subMsg model.counterModel }

        ElmUICounterMsg subMsg ->
            { model | elmUiCounterModel = ElmUICounter.update subMsg model.elmUiCounterModel }

        HelloWorldMsg subMsg ->
            { model | helloWorldModel = HelloWorld.update subMsg model.helloWorldModel }


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.map HelloWorldMsg <| HelloWorld.view model.helloWorldModel
        , Html.br [] []
        , Html.map CounterMsg <| Counter.view model.counterModel
        , Html.br [] []
        , Html.map ElmUICounterMsg <| ElmUICounter.view model.elmUiCounterModel
        ]
