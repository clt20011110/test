module Pentiminos exposing (random)

import Color exposing (Color)
import Grid exposing (Grid)
import Random


random : Random.Seed -> ( Grid Color, Random.Seed )
random seed =
    let
        shape0 =
            Random.uniform [ ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 3, 0 ), ( 4, 0 ) ] (List.drop 1 shape)

        colorr =
            Random.int 50 256

        colorg =
            Random.int 50 256

        colorb =
            Random.int 50 256

        color =
            Random.map3 (\x y z -> Color.rgb x y z) colorr colorg colorb

        pentimino =
            Random.map2 (\x y -> Grid.fromList x y) color shape0
    in
    Random.step pentimino seed


shape : List (List ( Int, Int ))
shape =
    [ [ ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 3, 0 ), ( 4, 0 ) ]
    , [ ( 3, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]
    , [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]
    , [ ( 1, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]
    , [ ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]
    , [ ( 1, 0 ), ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    , [ ( 1, 0 ), ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    , [ ( 0, 0 ), ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    , [ ( 3, 0 ), ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    , [ ( 1, 0 ), ( 0, 0 ), ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]
    , [ ( 0, 0 ), ( 0, 1 ), ( 0, 2 ), ( 1, 2 ), ( 2, 2 ) ]
    , [ ( 2, 0 ), ( 2, 1 ), ( 0, 2 ), ( 1, 2 ), ( 2, 2 ) ]
    , [ ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 0, 2 ) ]
    , [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 2, 2 ) ]
    , [ ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 1, 2 ) ]
    , [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 1, 2 ) ]
    , [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 0, 2 ) ]
    , [ ( 1, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 1, 2 ) ]
    ]
