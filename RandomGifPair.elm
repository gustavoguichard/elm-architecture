module RandomGifPair exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import RandomGif


main =
  App.program
    { init = init "surf" "cats"
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }


-- MODEL


type alias Model =
  { left : RandomGif.Model
  , right : RandomGif.Model
  }


init : String -> String -> ( Model, Cmd Msg )
init leftTopic rightTopic =
  let
    ( left, leftFx ) =
      RandomGif.init leftTopic

    ( right, rightFx ) =
      RandomGif.init rightTopic
  in
    Model left right
      ! [ Cmd.map Left leftFx
        , Cmd.map Right rightFx
        ]


-- UPDATE


type Msg
  = Left RandomGif.Msg
  | Right RandomGif.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    Left msg ->
      let
        ( left, fx ) =
          RandomGif.update msg model.left
      in
        Model left model.right ! [ Cmd.map Left fx ]

    Right msg ->
      let
        ( right, fx ) =
          RandomGif.update msg model.right
      in
        Model model.left right ! [ Cmd.map Right fx ]


-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
  (,)


view : Model -> Html Msg
view model =
  div
    [ style [ "display" => "flex" ] ]
    [ App.map Left (RandomGif.view model.left)
    , App.map Right (RandomGif.view model.right)
    ]
