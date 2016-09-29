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
  , loggedIn : Bool
  }


init : (Model, Cmd Msg)
init =
  (Model "" [] "Anon" False, Cmd.none)


-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String
  | UpdateName String
  | Login


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      ({ model | input = newInput }, Cmd.none)

    Send ->
      ({ model | input = "" }, WebSocket.send "ws://localhost:1234/messages" (model.name ++ ": " ++ model.input))

    NewMessage str ->
      ({ model | messages = (List.append model.messages [str]) }, Cmd.none)

    Login ->
      ({ model | loggedIn = (model.name /= "") }, Cmd.none)

    UpdateName newName ->
      ({ model | name = newName }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://localhost:1234/messages" NewMessage


-- VIEW

view : Model -> Html Msg
view model =
  if model.loggedIn then
    messageView model
  else
    loginView model


loginView : Model -> Html Msg
loginView model =
  div []
    [ h1 [] [text "Welcome to Messages!"]
    , div []
        [ text "What's your name?"
        , input [onInput UpdateName] []
        , button [onClick Login] [text "Log In"]
        ]
    ]

messageView : Model -> Html Msg
messageView model =
  div []
    [ div [] (List.map viewMessage model.messages)
    , text (model.name ++ ": ")
    , input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
