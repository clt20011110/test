module View exposing (..)

import Debug exposing (toString)
import Html as Html
import Html.Attributes as HtmlAttr
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Types exposing (..)


view_blast : Blast -> Svg Msg
view_blast blast =
    let
        ( x, y ) =
            blast.pos

        color =
            case blast.ship_type of
                Main ->
                    "#ff0026d2"

                Enemy ->
                    "#6aff149f"
    in
    Svg.rect
        [ SvgAttr.width "20"
        , SvgAttr.height "5"
        , SvgAttr.x (toString x)
        , SvgAttr.y (toString y)
        , SvgAttr.fill color
        ]
        []


view_ship : Ship -> Svg Msg
view_ship ship =
    let
        ( x, y ) =
            ship.pos

        link =
            case ship.ship_type of
                Main ->
                    "image/mainship.png"

                Enemy ->
                    "image/enemy.png"
    in
    Svg.image
        [ SvgAttr.width "130"
        , SvgAttr.height "70"
        , SvgAttr.x (toString x)
        , SvgAttr.y (toString y)
        , SvgAttr.xlinkHref link
        ]
        []


view : Model -> Html.Html Msg
view model =
    Html.div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background" "#2E1F5F6F"
        ]
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            (List.map view_ship model.ships
                ++ List.map view_blast model.blasts
            )
        ]
