module Exercise2 exposing (..)


func1 : Int -> List Int
func1 x =
    if (x - 1) == 0 then
        [ 0 ]

    else
        func1 (x - 1) ++ [ 2 * (x - 1) ]


func2 : List Int -> Int -> Int
func2 x y =
    List.length (List.filter (\num -> num == y) x)


func3 : ( Int, Int ) -> List (List Int)
func3 ( x, y ) =
    List.repeat x (List.range 0 (y - 1))


func4 : Int -> List Int -> Int
func4 x y =
    List.drop (x - 1) y
        |> List.head
        |> Maybe.withDefault 100


func5 : Int -> List Int
func5 x =
    if x == 1 then
        [ 1 ]

    else if x == 2 then
        [ 1, 1 ]

    else
        func5 (x - 1) ++ [ func5 (x - 1) |> List.drop (x - 3) |> List.sum ]


isRepeated : Int -> List Int -> Bool
isRepeated a b =
    if (List.length b - List.length (List.filter (\num -> num /= a) b)) >= 2 then
        True

    else
        False


func6 : List Int -> List Int
func6 a =
    List.filter (\num -> not (isRepeated num a)) a


find : List ( String, Int ) -> ( String, Int ) -> Int
find a b =
    if (List.head a |> Maybe.withDefault ( "", 0 )) == b then
        0

    else
        find (List.drop 1 a) b + 1


func7 : List ( String, Int ) -> ( String, Int ) -> List ( String, Int )
func7 a b =
    let
        place =
            find a b
    in
    (List.take place a ++ [ ( "", 0 ) ]) ++ List.drop (place + 1) a
