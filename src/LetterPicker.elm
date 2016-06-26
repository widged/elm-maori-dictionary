module LetterPicker exposing (Model, initialModel, Msg (SelectionChange), render, update, selectedLetter)

import Html exposing (Html, node, div, ul, text, button)
import Html.Events exposing (onClick)
import Array exposing (Array)
import Task exposing (Task)

type InternalEvent = Next | Previous | Selection Int
type Msg = InternalMsg InternalEvent | SelectionChange

type alias Model =
  { selectedIdx: Int
  , letters: Array String
  , defaultIdx : Int
  }

initialModel : Model
initialModel =
  { selectedIdx = 0
  , letters = Array.fromList ["A","E","H","I","K","M","N","Ng","O","P","R","T","U","W"]
  , defaultIdx = 0
  }

selectedLetter : Model -> String
selectedLetter model =
  let
    maybe = Array.get model.selectedIdx model.letters
  in
    case maybe of
      Just letter ->
        letter
      Nothing ->
        Maybe.withDefault "" (Array.get model.defaultIdx model.letters)

updateIndex msg model idx = ( { model | selectedIdx = idx }, Task.perform (\_ -> SelectionChange) (\_ -> SelectionChange) (Task.succeed "ok")) -- Change needs to be a function, associated with a constructor
-- log = Debug.log "updateIndex" (updateIndex 3)
-- updateIndex: ({ type = "leaf", home = "Task", value = T <task> })

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      InternalMsg Next ->
        updateIndex msg model (model.selectedIdx + 1)
      InternalMsg Previous ->
        updateIndex msg model (model.selectedIdx - 1)
      InternalMsg (Selection idx) ->
        updateIndex msg model idx
      _ ->
        ( model, Cmd.none)

render : Model -> Html Msg
render model =
  let
    renderLetter (idx, letter) = node "li" [onClick (InternalMsg (Selection idx))] [text letter]
    letters = List.map renderLetter (Array.toIndexedList model.letters)
  in
    node "letter-picker" []
      [ ul [] letters
      -- , button [ onClick (InternalMsg Next) ] [ text "next" ]
      ]
