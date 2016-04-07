module App (..) where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import DynamicGifs
import Background


-- MODEL


type alias Vect =
  ( Int, Int )


type alias Model =
  { gifs : DynamicGifs.Model
  , background : Background.Model
  }


init : ( Model, Effects Action )
init =
  let
    ( gifsModel, fx ) =
      DynamicGifs.init ""
  in
    ( Model gifsModel Background.init
    , Effects.batch
        [ Effects.map Gifs fx
        ]
    )



-- UPDATE


type Action
  = Gifs DynamicGifs.Action
  | WindowEvents Vect Vect
  | NoOp


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    Gifs act ->
      let
        ( gifs, fx ) =
          DynamicGifs.update act model.gifs
      in
        ( { model | gifs = gifs }
        , Effects.map Gifs fx
        )

    WindowEvents window mouse ->
      let
        background =
          Background.update (Background.Change window mouse) model.background
      in
        ( { model | background = background }
        , Effects.none
        )

    NoOp ->
      ( model, Effects.none )



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ DynamicGifs.view (Signal.forwardTo address Gifs) model.gifs
    , div
        [ style
            [ ( "position", "absolute" )
            , ( "top", "0" )
            , ( "z-index", "1" )
            , ( "pointer-events", "none" )
            ]
        ]
        [ Background.view model.background ]
    ]
