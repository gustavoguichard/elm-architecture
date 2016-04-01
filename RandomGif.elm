module RandomGif (..) where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Task


-- CONFIG


loadingImg =
  "assets/waiting.gif"



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  }


init : String -> ( Model, Effects Action )
init topic =
  ( Model topic loadingImg
  , getRandomGif topic
  )



-- UPDATE


type Action
  = RequestMore
  | NewGif (Maybe String)


update : Action -> Model -> ( Model, Effects Action )
update msg model =
  case msg of
    RequestMore ->
      ( { model
          | gifUrl = loadingImg
        }
      , getRandomGif model.topic
      )

    NewGif maybeUrl ->
      ( { model
          | gifUrl = Maybe.withDefault model.gifUrl maybeUrl
        }
      , Effects.none
      )



-- VIEW


(=>) =
  (,)


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ style [ "width" => "200px" ] ]
    [ h2 [ headerStyle ] [ text model.topic ]
    , div [ imgStyle model.gifUrl ] []
    , button [ onClick address RequestMore ] [ text "More Please!" ]
    ]


headerStyle : Attribute
headerStyle =
  style
    [ "width" => "200px"
    , "text-align" => "center"
    ]


imgStyle : String -> Attribute
imgStyle url =
  style
    [ "display" => "inline-block"
    , "width" => "200px"
    , "height" => "200px"
    , "background-position" => "center"
    , "background-size" => "cover"
    , "background-image" => ("url('" ++ url ++ "')")
    ]



-- EFFECTS


getRandomGif : String -> Effects Action
getRandomGif topic =
  Http.get decodeUrl (randomUrl topic)
    |> Task.toMaybe
    |> Task.map NewGif
    |> Effects.task


randomUrl : String -> String
randomUrl topic =
  Http.url
    "http://api.giphy.com/v1/gifs/random"
    [ "api_key" => "dc6zaTOxFJmzC"
    , "tag" => topic
    ]


decodeUrl : Json.Decoder String
decodeUrl =
  Json.at [ "data", "image_url" ] Json.string
