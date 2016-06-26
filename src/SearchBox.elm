module SearchBox exposing (Model, initialModel, Msg (SearchWord), render, update)

import Html exposing (Html, node, div, ul, text, button, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Array exposing (Array)
import Task exposing (Task)

type InternalEvent = Search | Selection Int | WordChange String
type Msg = InternalMsg InternalEvent | SearchWord String

type alias Model =
  { word: String
  }

initialModel : Model
initialModel =
  { word = ""
  }


-- updateIndex msg model idx = ( { model | selectedIdx = idx }, Task.perform (\_ -> SelectionChange) (\_ -> SelectionChange) (Task.succeed "ok")) -- Change needs to be a function, associated with a constructor
-- log = Debug.log "updateIndex" (updateIndex 3)
-- updateIndex: ({ type = "leaf", home = "Task", value = T <task> })

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      InternalMsg (WordChange str) ->
        ( { model | word = str }, Cmd.none)
      _ ->
        ( model, Cmd.none)

render : Model -> Html Msg
render model =
  let
    z = 1
  in
    node "letter-picker" []
      [ input [ type' "search", name "search", placeholder "Search for a word", onInput (\x -> InternalMsg (WordChange x))] []
      , button [ onClick (SearchWord model.word) ] [ text "search" ]
      ]
