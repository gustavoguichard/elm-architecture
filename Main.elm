--module Main exposing (..)

import App exposing (init, update, view, Model, Msg)
import Html.App as App
import Task
import Html
import Mouse exposing (moves)
import Window exposing (resizes)


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch [ resizes App.WindowResize, moves App.MouseMove ]


main : Program Never
main =
  App.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
