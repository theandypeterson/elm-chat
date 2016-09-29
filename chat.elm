import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { input : String
  , messages : List String
  , name : String
  , signedIn : Bool
  }


init : (Model, Cmd Msg)
init =
  (Model "" [] "Anon" False, Cmd.none)


-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String
  | SignIn String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      ({ model | input = newInput }, Cmd.none)

    Send ->
      ({ model | input = "" }, WebSocket.send "ws://localhost:1234/messages" model.input)

    NewMessage str ->
      ({ model | messages = (List.append model.messages [str]) }, Cmd.none)

    SignIn name ->
      ({ model | name = name, signedIn = True }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://localhost:1234/messages" NewMessage


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map viewMessage model.messages)
    , input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
