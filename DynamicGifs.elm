module DynamicGifs exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Json.Decode as Json
import RandomGif


main =
  App.program
    { init = init "surf"
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }


-- MODEL


type alias ID =
  Int


type alias Model =
  { topic : String
  , gifList : List ( ID, RandomGif.Model )
  , uid : ID
  }


init : String -> ( Model, Cmd Msg )
init topic =
  Model topic [] 0 ! []



-- UPDATE


type Msg
  = NoOp
  | Topic String
  | Create
  | SubMsg Int RandomGif.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    Topic topic ->
      { model | topic = topic } ! []

    Create ->
      let
        ( newRandomGif, fx ) =
          RandomGif.init model.topic

        newModel =
          Model "" (model.gifList ++ [ ( model.uid, newRandomGif ) ]) (model.uid + 1)
      in
        newModel ! [ Cmd.map (SubMsg model.uid) fx ]

    SubMsg msgId msg ->
      let
        subUpdate (( id, randomGif ) as entry) =
          if id == msgId then
            let
              ( newRandomGif, fx ) =
                RandomGif.update msg randomGif
            in
              ( id, newRandomGif ) ! [ Cmd.map (SubMsg id) fx ]
          else
            entry ! []

        ( newGifList, fxList ) =
          model.gifList
            |> List.map subUpdate
            |> List.unzip
      in
        { model
          | gifList = newGifList
        } ! fxList

    _ -> model ! []



-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
  (,)


view : Model -> Html Msg
view model =
  div
    []
    [ input
        [ placeholder "What kind of gifs do you want?"
        , value model.topic
        , onEnter NoOp Create
        , onInput Topic
        , inputStyle
        ]
        []
    , div
        [ style [ "display" => "flex", "flex-wrap" => "wrap" ] ]
        (List.map elementView model.gifList)
    ]


elementView : ( Int, RandomGif.Model ) -> Html Msg
elementView ( id, model ) =
  App.map (SubMsg id) (RandomGif.view model)


inputStyle : Attribute msg
inputStyle =
  style
    [ "width" => "100%"
    , "height" => "40px"
    , "padding" => "10px 0"
    , "font-size" => "2em"
    , "text-align" => "center"
    ]



-- EVENTS


onEnter : msg -> msg -> Attribute msg
onEnter fail success =
  let
    tagger code =
      if code == 13 then success
      else fail
  in
    on "keyup" (Json.map tagger keyCode)
