module Main exposing (main, update, view)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Time


screenWidth =
    500


screenHeight =
    500


shotVelocity =
    Vector 1 1


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Vector =
    { x : Float, y : Float }


type alias GameObject =
    { position : Vector, velocity : Vector, direction : Direction }


type alias Model =
    { robot : GameObject, shots : List GameObject }


type Direction
    = Right
    | Left
    | Up
    | Down


type Msg
    = Move Direction
    | Shoot
    | Interval


addVectors : Vector -> Vector -> Vector
addVectors baseVector addedVector =
    Vector (baseVector.x + addedVector.x) (baseVector.y + addedVector.y)


asShotsIn : Model -> List GameObject -> Model
asShotsIn model newShots =
    { model | shots = newShots }


asRobotIn : Model -> GameObject -> Model
asRobotIn model newRobot =
    { model | robot = newRobot }


asPositionIn : GameObject -> Vector -> GameObject
asPositionIn gameObject newPosition =
    { gameObject | position = newPosition }


asDirectionIn : GameObject -> Direction -> GameObject
asDirectionIn gameObject newDirection =
    { gameObject | direction = newDirection }



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    let
        robot =
            GameObject { x = 50, y = 50 } { x = 5, y = 5 } Up

        shots =
            []
    in
    ( Model robot shots, Cmd.none )



-- Update


inBorders : GameObject -> Bool
inBorders gameObject =
    let
        position =
            gameObject.position
    in
    position.x < screenWidth && position.x > 0 && position.y < screenHeight && position.y > 0


moveByVelocity : GameObject -> GameObject
moveByVelocity gameObject =
    { gameObject | position = addVectors gameObject.position gameObject.velocity }


moveShots : List GameObject -> List GameObject
moveShots shots =
    List.map moveByVelocity <| List.filter inBorders <| shots


directionToVelocity : Direction -> Vector -> Vector
directionToVelocity dir velocity =
    case dir of
        Right ->
            Vector velocity.x 0

        Left ->
            Vector -velocity.x 0

        Up ->
            Vector 0 -velocity.y

        Down ->
            Vector 0 velocity.y


moveRobot : Direction -> GameObject -> GameObject
moveRobot dir robot =
    let
        position =
            robot.position
    in
    asPositionIn robot <|
        addVectors position <|
            directionToVelocity dir robot.velocity


formatModelOutput : Model -> ( Model, Cmd Msg )
formatModelOutput model =
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    formatModelOutput <|
        case msg of
            Move dir ->
                asRobotIn model <|
                    let
                        movedRobot =
                            moveRobot dir <|
                                asDirectionIn model.robot dir
                    in
                    if inBorders movedRobot then
                        movedRobot

                    else
                        model.robot

            Shoot ->
                let
                    direction =
                        model.robot.direction

                    robotPosition =
                        model.robot.position
                in
                asShotsIn model <|
                    GameObject (Vector (robotPosition.x + 7) (robotPosition.y + 7))
                        (directionToVelocity direction shotVelocity)
                        direction
                        :: model.shots

            Interval ->
                asShotsIn model <|
                    moveShots model.shots



-- Subscriptions


toDirection : String -> Msg
toDirection keyCode =
    case keyCode of
        "ArrowRight" ->
            Move Right

        "ArrowLeft" ->
            Move Left

        "ArrowUp" ->
            Move Up

        "ArrowDown" ->
            Move Down

        " " ->
            Shoot

        _ ->
            Move Right


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map toDirection (Decode.field "key" Decode.string)


frameRate amount =
    1 / amount


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (frameRate 30) (always Interval)
        , Browser.Events.onKeyDown keyDecoder
        ]



-- View


toDegrees : Direction -> String
toDegrees dir =
    (String.fromInt <|
        case dir of
            Right ->
                90

            Left ->
                -90

            Up ->
                0

            Down ->
                180
    )
        ++ "deg"


view : Model -> Html Msg
view model =
    let
        robotPos =
            model.robot.position
    in
    div
        [ style "width" (String.fromInt screenWidth ++ "px")
        , style "height" (String.fromInt screenHeight ++ "px")
        , style "border" "solid 1px #000"
        ]
        [ div
            [ style "left" (String.fromFloat robotPos.x ++ "px")
            , style "top" (String.fromFloat robotPos.y ++ "px")
            , style "backgroundColor" "#00c"
            , style "width" "24px"
            , style "height" "28px"
            , style "position" "absolute"
            , style "transform" <| "rotate(" ++ toDegrees model.robot.direction ++ ")"
            , style "transition" "0.3s all ease"
            , style "borderRadius" "3px"
            ]
            [ div
                [ style "backgroundColor" "#444"
                , style "position" "relative"
                , style "left" "4px"
                , style "top" "4px"
                , style "width" "16px"
                , style "height" "20px"
                ]
                []
            ]
        , div
            []
            (List.map getShotView model.shots)
        ]


getShotView : GameObject -> Html Msg
getShotView shot =
    div
        [ style "left" (String.fromFloat shot.position.x ++ "px")
        , style "top" (String.fromFloat shot.position.y ++ "px")
        , style "backgroundColor" "#cf0"
        , style "width" "10px"
        , style "height" "10px"
        , style "borderRadius" "50%"
        , style "position" "absolute"
        ]
        []
