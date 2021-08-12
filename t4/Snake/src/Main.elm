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


type FruitType
    = Grape
    | Apple
    | Banana
    | Orange


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


type alias Fruit =
    { fruit_pos : ( Int, Int )
    , fruit_type : FruitType
    }


type alias Snake =
    { snake_body : List ( Int, Int )
    , snake_dir : Dir
    , snake_state : Live_status
    , snake_life : Int
    }


type alias Model =
    { snake : Snake
    , fruit : Fruit
    , move_timer : Float
    , score : Int
    }



-- MSG


type Msg
    = Key Dir
    | Key_None
    | State_Fruit ( ( Int, Int ), Int )
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
    Snake [ ( 1, 0 ), ( 0, 0 ) ] Right Alive 5


initFruit : Fruit
initFruit =
    Fruit ( 1, 1 ) Grape


initModel : Model
initModel =
    Model initSnake initFruit 0 0



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
                |> judgeLife
            , cmd
            )

        _ ->
            ( model, cmd )


timedForward : Model -> Model
timedForward model =
    let
        nbody =
            legalForward model.snake.snake_body model.snake.snake_dir model.fruit.fruit_pos
    in
    if model.move_timer >= stepTime then
        let
            snake =
                model.snake

            snake1 =
                { snake | snake_body = nbody }
        in
        { model | snake = snake1, move_timer = 0 }

    else
        model


stepTime : Float
stepTime =
    200


legalForward : List ( Int, Int ) -> Dir -> ( Int, Int ) -> List ( Int, Int )
legalForward body dir fruitpos =
    case List.head body of
        Nothing ->
            body

        Just oldhead ->
            let
                newhead =
                    headPos oldhead dir
            in
            forward body newhead fruitpos


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
    if x < -1 || x >= Tuple.first mapsize + 1 then
        Wall

    else if y < -1 || y >= Tuple.second mapsize + 1 then
        Wall

    else if List.member ( x, y ) body then
        Wall

    else
        Free


judgeLife : Model -> Model
judgeLife model =
    case headLegal (headPos (Maybe.withDefault ( 1, 1 ) (List.head model.snake.snake_body)) model.snake.snake_dir) model.snake.snake_body of
        Wall ->
            let
                snake =
                    model.snake

                snake1 =
                    initSnake

                judgesnake =
                    if snake.snake_life == 0 then
                        { snake | snake_state = Dead }

                    else
                        { snake1
                            | snake_life =
                                if snake.snake_life > 0 then
                                    snake.snake_life - 1

                                else
                                    snake.snake_life
                            , snake_state =
                                if snake.snake_life > 0 then
                                    Alive

                                else
                                    Dead
                        }
            in
            { model | snake = judgesnake }

        Free ->
            model


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
            if List.member model.fruit.fruit_pos model.snake.snake_body then
                let
                    fruit =
                        model.fruit

                    fruit1 =
                        { fruit | fruit_pos = ( -1, -1 ) }
                in
                ( { model | fruit = fruit1 }, Cmd.batch [ cmd, Random.generate State_Fruit fruitGen ] )

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

        State_Fruit fruit ->
            if List.member (Tuple.first fruit) model.snake.snake_body then
                ( model, Cmd.batch [ cmd, Random.generate State_Fruit fruitGen ] )

            else
                let
                    fruit2 =
                        model.fruit

                    fruit3 =
                        { fruit2
                            | fruit_pos = Tuple.first fruit
                            , fruit_type =
                                if Tuple.second fruit == 0 then
                                    Apple

                                else if Tuple.second fruit == 1 || Tuple.second fruit == 2 then
                                    Orange

                                else if Tuple.second fruit > 2 && Tuple.second fruit < 9 then
                                    Banana

                                else
                                    Grape
                        }
                in
                ( { model
                    | fruit = fruit3
                    , score =
                        case fruit2.fruit_type of
                            Apple ->
                                model.score + 100

                            Grape ->
                                model.score + 10

                            Banana ->
                                model.score + 20

                            Orange ->
                                model.score + 50
                  }
                , cmd
                )

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


fruitGen : Random.Generator ( ( Int, Int ), Int )
fruitGen =
    Random.pair (Random.pair (Random.int 0 (Tuple.first mapsize - 1)) (Random.int 0 (Tuple.second mapsize - 1))) (Random.int 0 18)



--View


gridsize : number
gridsize =
    25


mapsize : ( Int, Int )
mapsize =
    ( 20, 20 )


gridColor : Model -> ( Int, Int ) -> String
gridColor model pos =
    if List.member pos model.snake.snake_body then
        "black"

    else if model.fruit.fruit_pos == pos then
        case model.fruit.fruit_type of
            Apple ->
                "red"

            Grape ->
                "purple"

            Banana ->
                "yellow"

            Orange ->
                "orange"

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
        [ div [] [ text ("Score:" ++ String.fromInt model.score) ]
        , div [] [ text ("Life:" ++ String.repeat model.snake.snake_life "❤") ]
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
