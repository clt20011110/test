module Exercise2 exposing (..)
func : Int -> List Int -> Int
func x y =
    List.drop (x - 1) y
        |> List.head
        |> Maybe.withDefault 0