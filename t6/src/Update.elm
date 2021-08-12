module Update exposing (..)

import Types exposing (..)


appear_time : number
appear_time =
    300


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( animate (min time 25) model, Cmd.none )

        Noop ->
            ( model, Cmd.none )

        Go dir ->
            ( { model | ships = List.map (change_dir dir) model.ships }, Cmd.none )


animate :
    Float
    -> Model
    -> Model
animate elapsed model =
    let
        ( fltr_ships, fltr_blasts ) =
            List.foldl shoot ( [], model.blasts ) model.ships

        upd_blasts =
            List.foldl update_blast fltr_blasts model.ships

        upd_ships =
            List.filter (\nship -> nship.health >= 0) fltr_ships |> create_ship model.ship_time |> List.map (update_ship1 (elapsed / 10))

        ( upd_ships2, upd_blasts2 ) =
            ( upd_ships, upd_blasts ) |> (\( ships, blasts ) -> ( List.filter filter_pos ships, List.filter filter_pos blasts ))
    in
    { model
        | ships = upd_ships2
        , blasts = List.map (move_blast (elapsed / 10)) upd_blasts2
        , ship_time =
            if model.ship_time > appear_time then
                0

            else
                model.ship_time + elapsed / 10
    }


create_ship : Float -> List Ship -> List Ship
create_ship timer ships =
    if timer > 300 then
        init_ship Enemy :: ships

    else
        ships


init_ship : ShipType -> Ship
init_ship stype =
    let
        pos =
            if stype == Main then
                ( 0, 500 )

            else
                ( 1800, 500 )
    in
    Ship pos 100 stype Up 0


update_ship1 : Float -> Ship -> Ship
update_ship1 elapsed ship =
    let
        ( newdir, newpos ) =
            move_ship elapsed ship.dir ship.pos ship.ship_type

        def_time =
            case ship.ship_type of
                Main ->
                    20

                Enemy ->
                    10

        time =
            if ship.blast_time > def_time then
                0

            else
                ship.blast_time + 1
    in
    { ship | pos = newpos, dir = newdir, blast_time = time }


update_blast : Ship -> List Blast -> List Blast
update_blast ship blasts =
    let
        def_time =
            case ship.ship_type of
                Main ->
                    20

                Enemy ->
                    10

        ( sx, sy ) =
            ship.pos

        new_blasts =
            if ship.blast_time > def_time then
                Blast ( sx + 75, sy + 35 ) ship.ship_type :: blasts

            else
                blasts
    in
    new_blasts


move_ship : Float -> Dir -> ( Float, Float ) -> ShipType -> ( Dir, ( Float, Float ) )
move_ship elapsed dir ( sx, sy ) stype =
    let
        newdir =
            if sy < 0 then
                Down

            else if sy > 800 then
                Up

            else
                dir

        newpos =
            if stype == Main then
                ( sx, sy )

            else if dir == Up then
                ( sx - elapsed, sy - 3 * elapsed )

            else
                ( sx - elapsed, sy + 3 * elapsed )
    in
    ( newdir, newpos )


shoot :
    Ship
    -> ( List Ship, List Blast )
    -> ( List Ship, List Blast )
shoot ship ( ships, blasts ) =
    let
        surv_blasts =
            List.map (check_hit ship) blasts
                |> List.filter (\( _, elem ) -> not elem)

        hit_ship =
            { ship
                | health =
                    if List.length blasts /= List.length surv_blasts then
                        ship.health - 1

                    else
                        ship.health
            }
    in
    ( hit_ship :: ships, Tuple.first (List.unzip surv_blasts) )


check_hit : Ship -> Blast -> ( Blast, Bool )
check_hit ship blast =
    let
        ( bx, by ) =
            blast.pos

        ( sx, sy ) =
            ship.pos

        result =
            if ship.ship_type /= blast.ship_type then
                (bx + 20 >= sx && bx <= sx + 130)
                    && (by + 5 >= sy && by <= sy + 70)

            else
                False
    in
    ( blast, result )


filter_pos : { a | pos : ( Float, Float ) } -> Bool
filter_pos { pos } =
    let
        ( posx, _ ) =
            pos
    in
    posx > 0 || posx < 1800


move_blast : Float -> Blast -> Blast
move_blast elapsed blast =
    let
        ( x, y ) =
            blast.pos
    in
    if blast.ship_type == Main then
        { blast | pos = ( x + 15 * elapsed, y ) }

    else
        { blast | pos = ( x - 15 * elapsed, y ) }


change_dir : Dir -> Ship -> Ship
change_dir dir ship =
    let
        ( x, y ) =
            ship.pos

        npos =
            case ship.ship_type of
                Main ->
                    case dir of
                        Up ->
                            ( x, y + 10 )

                        Down ->
                            ( x, y - 10 )

                _ ->
                    ( x, y )
    in
    { ship | pos = npos }
