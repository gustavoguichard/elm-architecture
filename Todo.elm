module Todo exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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


type Msg
  = NoOp
  | ChangeVisibility String
  | UpdateEntryText String
  | Add
  | Toggle Int


update : Msg -> Model -> Model
update msg model =
  case msg of
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


view : Model -> Html Msg
view model =
  div
    []
    [ todoEntry model
    , todoList model
    , footer model
    ]


todoEntry : Model -> Html Msg
todoEntry model =
  div
    []
    [ input
        [ onInput UpdateEntryText
        , value model.entryText
        ]
        []
    , button
        [ onClick Add ]
        [ text "Add" ]
    ]


todoList : Model -> Html Msg
todoList model =
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
      (List.map todo tasks)


todo : Task -> Html Msg
todo model =
  let
    textDecoration =
      if model.completed then
        "line-through"
      else
        "none"
  in
    li
      [ onClick (Toggle model.id)
      , style [ ( "text-decoration", textDecoration ) ]
      ]
      [ text model.text ]


footer : Model -> Html Msg
footer model =
  let
    filterLink state =
      a
        [ href "#"
        , onClick (ChangeVisibility state)
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



-- MAIN

main : Program Never
main =
  App.beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }
