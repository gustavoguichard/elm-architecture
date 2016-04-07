module Background (..) where

import Graphics.Collage exposing (..)
import Color exposing (..)
import Html exposing (..)


-- MODEL


type alias Vect =
  ( Int, Int )


type alias Model =
  { window : Vect
  , mouse : Vect
  }


init : Model
init =
  Model ( 0, 0 ) ( 0, 0 )



-- UPDATE


type Action
  = Change Vect Vect


update : Action -> Model -> Model
update action model =
  case action of
    Change window mouse ->
      Model window mouse



-- VIEW


drawCircle : Float -> Float -> Form
drawCircle x y =
  circle 10
    |> filled red
    |> move ( x, y )


view : Model -> Html
view { mouse, window } =
  let
    ( w, h ) =
      window

    ( w', h' ) =
      ( toFloat w, toFloat h )

    x =
      toFloat (fst mouse) - (w' / 2)

    y =
      (h' / 2) - toFloat (snd mouse)
  in
    collage w h [ drawCircle x y ]
      |> fromElement
