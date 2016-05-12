module DynamicCounters exposing (..)

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
  | Remove
  | Modify ID Counter.Msg


init : Model
init =
  { counters = []
  , nextID = 1
  }


update : Msg -> Model -> Model
update msg model =
  case msg of
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


view : Model -> Html Msg
view model =
  let
    counters =
      List.map viewCounter model.counters
  in
    div
      []
      ([ button [ onClick Remove ] [ text "Remove" ]
       , button [ onClick Insert ] [ text "Add" ]
       ]
        ++ counters
      )


viewCounter : ( ID, Counter.Model ) -> Html Msg
viewCounter ( id, model ) =
  map (Modify id) (Counter.view model)
