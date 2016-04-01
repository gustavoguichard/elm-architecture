module ContextRemoveCounter (..) where

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
  | Remove ID
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
      { model
        | counters = model.counters ++ [ ( model.nextID, Counter.init 0 ) ]
        , nextID = model.nextID + 1
      }

    Remove id ->
      let
        diffFromId ( cID, _ ) =
          cID /= id
      in
        { model | counters = List.filter diffFromId model.counters }

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
    insert =
      button [ onClick address Insert ] [ text "Add" ]
  in
    div
      []
      (insert :: List.map (viewCounter address) model.counters)


viewCounter : Signal.Address Action -> ( ID, Counter.Model ) -> Html
viewCounter address ( id, model ) =
  let
    context =
      { actions = Signal.forwardTo address (Modify id)
      , remove = Signal.forwardTo address (always (Remove id))
      }
  in
    Counter.viewWithRemoveButton context model
