module CounterPairs (..) where

import Counter
import Html exposing (..)
import Html.Events exposing (..)
import StartApp.Simple exposing (start)


main =
  start
    { model = init 0 0
    , update = update
    , view = view
    }


type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }


type Action
  = Reset
  | Top Counter.Action
  | Bottom Counter.Action


init : Int -> Int -> Model
init top bottom =
  Model (Counter.init top) (Counter.init bottom)


update : Action -> Model -> Model
update action model =
  case action of
    Reset ->
      init 0 0

    Top act ->
      { model
        | topCounter = Counter.update act model.topCounter
      }

    Bottom act ->
      { model
        | bottomCounter = Counter.update act model.bottomCounter
      }


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ Counter.view (Signal.forwardTo address Top) model.topCounter
    , Counter.view (Signal.forwardTo address Bottom) model.bottomCounter
    , button [ onClick address Reset ] [ text "Reset" ]
    ]
