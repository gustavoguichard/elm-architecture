module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Task
import Mouse exposing (Position)
import Window exposing (Size)
import DynamicGifs
import Background as Bg


-- MODEL


type alias Vect =
  ( Int, Int )


type alias Model =
  { gifs : DynamicGifs.Model
  , background : Bg.Model
  }


init : ( Model, Cmd Msg )
init =
  let
    ( gifsModel, fx ) =
      DynamicGifs.init ""
  in
    Model gifsModel Bg.init
    ! [ Cmd.map Gifs fx
      , Task.perform EventFail WindowResize Window.size
      ]


-- UPDATE


type Msg
  = Gifs DynamicGifs.Msg
  | StartResize Bg.Msg
  | MouseMove Position
  | WindowResize Size
  | EventFail String
  | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    Gifs msg ->
      let
        ( gifs, fx ) = DynamicGifs.update msg model.gifs
      in
        { model | gifs = gifs } ! [ Cmd.map Gifs fx ]

    WindowResize size ->
      let
        window = ( size.width, size.height )
        bg = Bg.update (Bg.Resize window) model.background
        background = { window = bg.window, mouse = (((fst bg.window) // 2), ((snd bg.window) // 2)) }
      in
        { model | background = background } ! []

    MouseMove xy ->
      let
        mouse = ( xy.x, xy.y )
        bg = Bg.update (Bg.Move mouse) model.background
      in
        { model | background = bg } ! []

    _ ->
      model ! []



-- VIEW


view : Model -> Html Msg
view model =
  div
    []
    [ App.map Gifs (DynamicGifs.view model.gifs)
    , div
        [ style
            [ ( "position", "absolute" )
            , ( "top", "0" )
            , ( "z-index", "1" )
            , ( "pointer-events", "none" )
            ]
        ]
        [ App.map (always NoOp) (Bg.view model.background) ]
    ]
