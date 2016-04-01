module DynamicCounters (..) where

import Counter
import Html exposing (..)
import Html.Events exposing (..)
import StartApp.Simple exposing (start)


main =
  start
    { model = init
    , update = update
    , view = view
    }


type alias Model =
  { counters : List ( ID, Counter.Model )
  , nextID : ID
  }


type alias ID =
  Int


type Action
  = Insert
  | Remove
  | Modify ID Counter.Action


init : Model
init =
  { counters = []
  , nextID = 1
  }


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      let
        newCounter =
          ( model.nextID, Counter.init 0 )
      in
        { model
          | counters = model.counters ++ [ newCounter ]
          , nextID = model.nextID + 1
        }

    Remove ->
      { model | counters = List.drop 1 model.counters }

    Modify id act ->
      let
        updateCounter ( counterID, counterModel ) =
          if counterID == id then
            ( counterID, Counter.update act counterModel )
          else
            ( counterID, counterModel )
      in
        { model | counters = List.map updateCounter model.counters }


view : Signal.Address Action -> Model -> Html
view address model =
  let
    counters =
      List.map (viewCounter address) model.counters
  in
    div
      []
      ([ button [ onClick address Remove ] [ text "Remove" ]
       , button [ onClick address Insert ] [ text "Add" ]
       ]
        ++ counters
      )


viewCounter : Signal.Address Action -> ( ID, Counter.Model ) -> Html
viewCounter address ( id, model ) =
  Counter.view (Signal.forwardTo address (Modify id)) model
