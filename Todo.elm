module Todo (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)


-- Model


type alias Task =
  { id : Int
  , text : String
  , completed : Bool
  }


type alias Model =
  { tasks : List Task
  , visibility : String
  , entryText : String
  , uid : Int
  }


createTask : Int -> String -> Task
createTask id text =
  { id = id
  , text = text
  , completed = False
  }


initialModel : Model
initialModel =
  { tasks = []
  , visibility = "All"
  , entryText = ""
  , uid = 1
  }



-- UPDATE


type Action
  = NoOp
  | ChangeVisibility String
  | UpdateEntryText String
  | Add
  | Toggle Int


update : Action -> Model -> Model
update action model =
  case action of
    ChangeVisibility visibility ->
      { model | visibility = visibility }

    Add ->
      { model
        | tasks = model.tasks ++ [ createTask model.uid model.entryText ]
        , entryText = ""
        , uid = model.uid + 1
      }

    Toggle id ->
      let
        updateTask task =
          if task.id == id then
            { task | completed = not task.completed }
          else
            task
      in
        { model
          | tasks = List.map updateTask model.tasks
        }

    UpdateEntryText text ->
      { model | entryText = text }

    NoOp ->
      model



-- VIEW


view : Address Action -> Model -> Html
view address model =
  div
    []
    [ todoEntry address model
    , todoList address model
    , footer address model
    ]


todoEntry : Address Action -> Model -> Html
todoEntry address model =
  div
    []
    [ input
        [ on "input" targetValue (Signal.message address << UpdateEntryText)
        , value model.entryText
        ]
        []
    , button
        [ onClick address Add ]
        [ text "Add" ]
    ]


todoList : Address Action -> Model -> Html
todoList address model =
  let
    tasks =
      case model.visibility of
        "Completed" ->
          List.filter .completed model.tasks

        "Active" ->
          List.filter (not << .completed) model.tasks

        _ ->
          model.tasks
  in
    ul
      []
      (List.map (todo address) tasks)


todo : Address Action -> Task -> Html
todo address model =
  let
    textDecoration =
      if model.completed then
        "line-through"
      else
        "none"
  in
    li
      [ onClick address (Toggle model.id)
      , style [ ( "text-decoration", textDecoration ) ]
      ]
      [ text model.text ]


footer : Address Action -> Model -> Html
footer address model =
  let
    filterLink state =
      a
        [ href "#"
        , onClick address (ChangeVisibility state)
        ]
        [ text state ]
  in
    p
      []
      [ text "Filters: "
      , filterLink "All"
      , text " "
      , filterLink "Active"
      , text " "
      , filterLink "Completed"
      ]



-- SIGNALS


actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


appModel : Signal Model
appModel =
  Signal.foldp update initialModel actions.signal


main : Signal Html
main =
  Signal.map (view actions.address) appModel
