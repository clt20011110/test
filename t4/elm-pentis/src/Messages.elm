module Messages exposing (Msg(..))

import Browser.Dom exposing (Viewport)


type Msg
    = Start
    | Tick Float
    | UnlockButtons
    | MoveLeft Bool
    | MoveRight Bool
    | Rotate Bool
    | Accelerate Bool
    | Resize Int Int
    | GetViewport Viewport
    | Noop
