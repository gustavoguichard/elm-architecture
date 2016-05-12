module Main exposing (..)

import App exposing (init, update, view, Model, Msg)
import Html.App as App
import Task
import Html
import Mouse as M
import Window as W


subscriptions : Sub a
subscriptions =
  Sub.batch [ W.resizes, M.moves ]


main : Program Never
main =
  App.program
    { init = init
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }
