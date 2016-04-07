module Main (..) where

import Effects exposing (Never)
import App exposing (init, update, view, Model, Action)
import StartApp
import Task
import Html
import Mouse as M
import Window as W


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ inputs ]
    }


inputs : Signal Action
inputs =
  Signal.map2 App.WindowEvents W.dimensions M.position


main : Signal Html.Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
