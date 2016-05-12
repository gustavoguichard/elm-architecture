module Background exposing (..)

import Collage exposing (..)
import Element exposing (toHtml)
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


type Msg
  = Change Vect Vect


update : Msg -> Model -> Model
update msg model =
  case msg of
    Change window mouse ->
      Model window mouse



-- VIEW


drawCircle : Float -> Float -> Form
drawCircle x y =
  circle 10
    |> filled red
    |> move ( x, y )


view : Model -> Html Msg
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
      |> toHtml
