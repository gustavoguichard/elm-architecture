module RandomGif exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Http
import Json.Decode as Json
import Task

main =
  App.program
    { init = init "surf"
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }


-- CONFIG


loadingImg : String
loadingImg =
  "assets/waiting.gif"



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  }


init : String -> ( Model, Cmd Msg )
init topic =
  ( Model topic loadingImg
  , getRandomGif topic
  )



-- UPDATE


type Msg
  = NoOp
  | RequestMore
  | FetchSuccess String
  | FetchFail Http.Error
  | Type String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    RequestMore ->
      { model
        | gifUrl = loadingImg
      } ! [ getRandomGif model.topic ]

    FetchSuccess url ->
      { model | gifUrl = url } ! []

    Type input ->
      { model
        | topic = input
      } ! []

    _ ->
      model ! []



-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
  (,)


view : Model -> Html Msg
view model =
  div
    [ wrapperStyle ]
    [ h2 [ headerStyle ] [ text model.topic ]
    , input
        [ style [ "padding" => "10px" ]
        , value model.topic
        , onInput Type
        , onEnter NoOp RequestMore
        ]
        []
    , div [ imgStyle model.gifUrl ] []
    , button [ onClick RequestMore ] [ text "More Please!" ]
    ]


wrapperStyle : Attribute msg
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


headerStyle : Attribute msg
headerStyle =
  style
    [ "width" => "200px"
    , "text-align" => "center"
    ]


imgStyle : String -> Attribute msg
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


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  Http.get decodeUrl (randomUrl topic)
    |> Task.perform FetchFail FetchSuccess


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


onEnter : msg -> msg -> Attribute msg
onEnter fail success =
  let
    tagger code =
      if code == 13 then success
      else fail
  in
    on "keyup" (Json.map tagger keyCode)
