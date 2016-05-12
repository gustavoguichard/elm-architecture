module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (map)
import DynamicGifs
import Background


-- MODEL


type alias Vect =
  ( Int, Int )


type alias Model =
  { gifs : DynamicGifs.Model
  , background : Background.Model
  }


init : ( Model, Cmd Msg )
init =
  let
    ( gifsModel, fx ) =
      DynamicGifs.init ""
  in
    Model gifsModel Background.init ! [ Cmd.map Gifs fx ]


-- UPDATE


type Msg
  = Gifs DynamicGifs.Msg
  | WindowEvents Vect Vect
  | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    Gifs msg ->
      let
        ( gifs, fx ) =
          DynamicGifs.update msg model.gifs
      in
        { model | gifs = gifs } ! [ Cmd.map Gifs fx ]

    WindowEvents window mouse ->
      let
        background =
          Background.update (Background.Change window mouse) model.background
      in
        { model | background = background } ! []

    NoOp ->
      model ! []



-- VIEW


view : Model -> Html Msg
view model =
  div
    []
    [ map Gifs (DynamicGifs.view model.gifs)
    , div
        [ style
            [ ( "position", "absolute" )
            , ( "top", "0" )
            , ( "z-index", "1" )
            , ( "pointer-events", "none" )
            ]
        ]
        [ map (always NoOp) (Background.view model.background) ]
    ]
