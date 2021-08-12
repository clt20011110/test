module Dnd exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)


type alias Model =
    { race : Race, class : Class, armor : Armor }


type Race
    = Human
    | Elf


type Class
    = Base
    | Middle
    | Domain


type Armor
    = Shield
    | Plate
    | Mail


showRace : Model -> String
showRace a =
    case a.race of
        Human ->
            "You are a human."

        Elf ->
            "You are an elf."


showClass : Model -> String
showClass a =
    case a.class of
        Base ->
            "You are in the base class."

        Middle ->
            "You are in the middle class."

        Domain ->
            "You are in the domain class."


showArmor : Model -> String
showArmor a =
    case a.armor of
        Shield ->
            "You own a shield."

        Plate ->
            "You own a plate."

        Mail ->
            "You own a mail."



--Init


init : Model
init =
    { race = Human, class = Base, armor = Shield }



--Main


main : Html msg
main =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ div [] [ text (init |> showRace) ]
        , div [] [ text (init |> showClass) ]
        , div [] [ text (init |> showArmor) ]
        ]
