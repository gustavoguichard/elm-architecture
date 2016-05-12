module CounterPairs exposing (..)

import Counter
import Html exposing (..)
import Html.Events exposing (..)
import Html.App exposing (beginnerProgram, map)


main =
  beginnerProgram
    { model = init 0 0
    , update = update
    , view = view
    }


type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }


type Msg
  = Reset
  | Top Counter.Msg
  | Bottom Counter.Msg


init : Int -> Int -> Model
init top bottom =
  Model (Counter.init top) (Counter.init bottom)


update : Msg -> Model -> Model
update msg model =
  case msg of
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


view : Model -> Html Msg
view model =
  div
    []
    [ map Top (Counter.view model.topCounter)
    , map Bottom (Counter.view model.bottomCounter)
    , button [ onClick Reset ] [ text "Reset" ]
    ]
