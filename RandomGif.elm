module RandomGif (..) where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task


-- CONFIG


loadingImg : String
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
  | Type String


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

    Type input ->
      ( { model
          | topic = input
        }
      , Effects.none
      )



-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
  (,)


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ wrapperStyle ]
    [ h2 [ headerStyle ] [ text model.topic ]
    , input
        [ style [ "padding" => "10px" ]
        , value model.topic
        , on "input" targetValue (Signal.message address << Type)
        , onEnter address RequestMore
        ]
        []
    , div [ imgStyle model.gifUrl ] []
    , button [ onClick address RequestMore ] [ text "More Please!" ]
    ]


wrapperStyle : Attribute
wrapperStyle =
  style
    [ "width" => "200px"
    , "display" => "flex"
    , "margin" => "10px auto"
    , "text-align" => "center"
    , "flex-direction" => "column"
    , "justify-content" => "space-around"
    , "height" => "400px"
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
    , "background-size" => "contain"
    , "background-repeat" => "no-repeat"
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



-- EVENTS


onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
  on
    "keydown"
    (Json.customDecoder keyCode is13)
    (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then
    Ok ()
  else
    Err "not the right key code"
