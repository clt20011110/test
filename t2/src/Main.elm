module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown)
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Random
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


type Dir
    = Up
    | Down
    | Left
    | Right


type Movable
    = Wall
    | Free


type Live_status
    = Alive
    | Dead


type alias Snake =
    { snake_body : List ( Int, Int )
    , snake_dir : Dir
    , snake_state : Live_status
    }


type alias Model =
    { snake : Snake
    , fruit_pos : ( Int, Int )
    , move_timer : Float
    }



-- MSG


type Msg
    = Key Dir
    | Key_None
    | Place_Fruit ( Int, Int )
    | Tick Float



--MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



--INITIALIZATION


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initSnake : Snake
initSnake =
    Snake [ ( 1, 0 ), ( 0, 0 ) ] Right Alive


initModel : Model
initModel =
    Model initSnake ( 1, 1 ) 0



--UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
        |> updateSnake msg
        |> updateFruit msg


updateSnake : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateSnake msg ( model, cmd ) =
    case msg of
        Tick elapsed ->
            ( { model | move_timer = model.move_timer + elapsed }
                |> timedForward
            , cmd
            )

        _ ->
            ( model, cmd )


timedForward : Model -> Model
timedForward model =
    let
        ( nbody, nstate ) =
            legalForward model.snake.snake_body model.snake.snake_dir model.snake.snake_state model.fruit_pos
    in
    if model.move_timer >= stepTime then
        let
            snake =
                model.snake

            snake1 =
                { snake | snake_body = nbody, snake_state = nstate }
        in
        { model | snake = snake1, move_timer = 0 }

    else
        model


stepTime : Float
stepTime =
    200


legalForward : List ( Int, Int ) -> Dir -> Live_status -> ( Int, Int ) -> ( List ( Int, Int ), Live_status )
legalForward body dir state fruitpos =
    case List.head body of
        Nothing ->
            ( body, state )

        Just oldhead ->
            let
                newhead =
                    headPos oldhead dir
            in
            if headLegal newhead body == Free then
                ( forward body newhead fruitpos, state )

            else
                ( body, Dead )


headPos : ( Int, Int ) -> Dir -> ( Int, Int )
headPos ( oldx, oldy ) dir =
    case dir of
        Up ->
            ( oldx, oldy - 1 )

        Down ->
            ( oldx, oldy + 1 )

        Right ->
            ( oldx + 1, oldy )

        Left ->
            ( oldx - 1, oldy )


headLegal : ( Int, Int ) -> List ( Int, Int ) -> Movable
headLegal ( x, y ) body =
    if x < 0 || x >= Tuple.first mapsize then
        Wall

    else if y < 0 || y >= Tuple.second mapsize then
        Wall

    else if List.member ( x, y ) body then
        Wall

    else
        Free


forward : List ( Int, Int ) -> ( Int, Int ) -> ( Int, Int ) -> List ( Int, Int )
forward body newhead fruitpos =
    if headLegal newhead body == Wall then
        body

    else if getFruit newhead fruitpos then
        body
            |> putHead newhead

    else
        body
            |> putHead newhead
            |> removeTail


getFruit : ( Int, Int ) -> ( Int, Int ) -> Bool
getFruit head fruit =
    fruit == head


putHead : ( Int, Int ) -> List ( Int, Int ) -> List ( Int, Int )
putHead newhead body =
    List.append [ newhead ] body


removeTail : List a -> List a
removeTail body =
    body
        |> List.reverse
        |> List.tail
        |> Maybe.withDefault []
        |> List.reverse


updateFruit : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateFruit msg ( model, cmd ) =
    case msg of
        Tick _ ->
            if List.member model.fruit_pos model.snake.snake_body then
                ( { model | fruit_pos = ( -1, -1 ) }, Cmd.batch [ cmd, Random.generate Place_Fruit fruitGen ] )

            else
                ( model, cmd )

        Key dir ->
            let
                snake1 =
                    model.snake

                snake =
                    changeDir snake1 dir
            in
            ( { model
                | snake = snake
              }
            , cmd
            )

        Place_Fruit fruit_pos ->
            if List.member fruit_pos model.snake.snake_body then
                ( model, Cmd.batch [ cmd, Random.generate Place_Fruit fruitGen ] )

            else
                ( { model | fruit_pos = fruit_pos }, cmd )

        _ ->
            ( model, cmd )


changeDir : Snake -> Dir -> Snake
changeDir snake dir =
    { snake
        | snake_dir =
            if snake.snake_state == Alive then
                dir

            else
                snake.snake_dir
    }


fruitGen : Random.Generator ( Int, Int )
fruitGen =
    Random.pair (Random.int 0 (Tuple.first mapsize - 1)) (Random.int 0 (Tuple.second mapsize - 1))



--View


gridsize : number
gridsize =
    50


mapsize : ( Int, Int )
mapsize =
    ( 10, 10 )


gridColor : Model -> ( Int, Int ) -> String
gridColor model pos =
    if List.member pos model.snake.snake_body then
        "black"

    else if model.fruit_pos == pos then
        "red"

    else
        "white"


viewGrid : Model -> ( Int, Int ) -> Svg Msg
viewGrid model pos =
    let
        ( x, y ) =
            pos
    in
    Svg.rect
        [ SvgAttr.width (toString gridsize)
        , SvgAttr.height (toString gridsize)
        , SvgAttr.x (toString (x * gridsize))
        , SvgAttr.y (toString (y * gridsize))
        , SvgAttr.fill (gridColor model pos)
        , SvgAttr.stroke "black"
        ]
        []


range2d : ( Int, Int ) -> List ( Int, Int )
range2d size =
    let
        rangex =
            List.range 0 (Tuple.first size - 1)

        rangey =
            List.range 0 (Tuple.second size - 1)

        line =
            \y -> List.map (\x -> Tuple.pair x y) rangex
    in
    List.map line rangey
        |> List.concat


renderInfo : Live_status -> Html Msg
renderInfo state =
    div
        [ style "background" "rgba(75,0,130, 0.7)"
        , style "color" "#00FF00"
        , style "font-family" "Helvetica, Arial, sans-serif"
        , style "font-size" "50px"
        , style "font-weight" "bold"
        , style "line-height" "10"
        , style "position" "absolute"
        , style "top" "10"
        , style "width" "501px"
        , style "height" "501px"
        , style "display"
            (if state == Alive then
                "none"

             else
                "block"
            )
        ]
        [ text "You Died!"
        ]


view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ div [] [ text ("Score:" ++ String.fromInt ((List.length model.snake.snake_body - 2) * 10)) ]
        , renderInfo model.snake.snake_state
        , Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            (List.map (viewGrid model) (range2d mapsize))
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onKeyDown (Decode.map key keyCode)
        ]


key : Int -> Msg
key keycode =
    case keycode of
        38 ->
            Key Up

        40 ->
            Key Down

        37 ->
            Key Left

        39 ->
            Key Right

        _ ->
            Key_None
