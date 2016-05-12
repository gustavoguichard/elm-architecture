module Counter exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.App as App


main : Program Never
main =
  App.beginnerProgram
    { model = init 0
    , update = update
    , view = view
    }


type alias Model =
  Int


init : Int -> Model
init n =
  n


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      max (model - 1) 0


view : Model -> Html Msg
view model =
  div
    []
    [ button [ onClick Decrement ] [ text "-" ]
    , span [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]


viewWithRemoveButton context model =
  div
    []
    [ button [ onClick (context.actions Decrement) ] [ text "-" ]
    , span [] [ text (toString model) ]
    , button [ onClick (context.actions Increment) ] [ text "+" ]
    , button [ onClick context.remove ] [ text "X" ]
    ]
