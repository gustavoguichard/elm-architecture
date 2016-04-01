module Counter (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple exposing (start)


main =
  start
    { model = init 0
    , update = update
    , view = view
    }


type alias Model =
  Int


type alias Context =
  { actions : Signal.Address Action
  , remove : Signal.Address ()
  }


type Action
  = Increment
  | Decrement


init : Int -> Model
init n =
  n


update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      model + 1

    Decrement ->
      max (model - 1) 0


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ button [ onClick address Decrement ] [ text "-" ]
    , span [] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]


viewWithRemoveButton : Context -> Model -> Html
viewWithRemoveButton context model =
  div
    []
    [ button [ onClick context.actions Decrement ] [ text "-" ]
    , span [] [ text (toString model) ]
    , button [ onClick context.actions Increment ] [ text "+" ]
    , button [ onClick context.remove () ] [ text "X" ]
    ]
