module Main (..) where

import Effects exposing (Never)
import MyApp exposing (init, update, view)
import StartApp
import Task
import Html
import Mouse
import Window


app : StartApp.App MyApp.Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ inputs ]
    }


inputs : Signal MyApp.Action
inputs =
  Signal.map2 signalActions Window.dimensions Mouse.position


signalActions : ( Int, Int ) -> ( Int, Int ) -> MyApp.Action
signalActions window mouse =
  MyApp.WindowEvents window mouse


main : Signal Html.Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
