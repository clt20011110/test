module Main exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Types exposing (..)
import Update exposing (init_ship, update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INITIALIZATION


init : () -> ( Model, Cmd Msg )
init =
    let
        model =
            { ships = [ init_ship Main ], blasts = [], ship_time = 0 }
    in
    \() -> ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ onKeyDown (Decode.map key keyCode), onAnimationFrameDelta Tick ]


key : Int -> Msg
key keycode =
    case keycode of
        40 ->
            Go Up

        38 ->
            Go Down

        _ ->
            Noop
