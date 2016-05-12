module ContextRemoveCounter exposing (..)

import Counter
import Html exposing (..)
import Html.Events exposing (..)
import Html.App exposing (beginnerProgram, map)


main =
  beginnerProgram
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


type Msg
  = Insert
  | Remove ID
  | Modify ID Counter.Msg


init : Model
init =
  { counters = []
  , nextID = 1
  }


update : Msg -> Model -> Model
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


view : Model -> Html Msg
view model =
  let
    insert =
      button [ onClick Insert ] [ text "Add" ]
  in
    div
      []
      (insert :: List.map viewCounter model.counters)


viewCounter : ( ID, Counter.Model ) -> Html Msg
viewCounter ( id, model ) =
  let
    context = Counter.Context (Modify id) (Remove id)
  in
    Counter.viewWithRemoveButton context model
