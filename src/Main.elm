module Main exposing (..)

import Html.App as App
import Html exposing (Html, node, div, text)
import Html.Attributes as Attr
import Array exposing (Array)
import Ports exposing (..)
import VirtualDom exposing (property, Property)
import Json.Encode as Json

import LetterPicker
import SearchBox


main : Program Never
main =
    App.program
        { init = initStore ! []
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- INTERACTIVITY

type Msg = LetterPickerMsg String LetterPicker.Msg | SearchBoxMsg String SearchBox.Msg | SetRows (Ports.Rows)

subscriptions : Store -> Sub Msg
subscriptions store =
  Ports.setRows SetRows

update : Msg -> Store -> ( Store, Cmd Msg )
update msg store =
    let
      log = Debug.log "msg" msg
    in
    case msg of
        SetRows rows ->
          { store | rows = rows } ! []
        SearchBoxMsg uid wgMsg ->
          case wgMsg of
            SearchBox.SearchWord word  ->
              let
                log = Debug.log "search" word
              in
                ( store, Ports.wordChange word )
            -- DON'T FORGET TO FORWARD ALL INTERNAL EVENTS
            _ ->
              let
                ( newModel, cmd ) = SearchBox.update wgMsg store.eSearchBox
                log = Debug.log "box" wgMsg
              in
                { store | eSearchBox = newModel } ! [ Cmd.map (SearchBoxMsg "uid") cmd ]

        LetterPickerMsg uid wgMsg ->
          case wgMsg of
            LetterPicker.SelectionChange  ->
              let
                selectedLetter = LetterPicker.selectedLetter store.eLetterPicker
                log = Debug.log "letter" selectedLetter
              in
                ( store, Ports.letterChange selectedLetter )
            -- DON'T FORGET TO FORWARD ALL INTERNAL EVENTS
            _ ->
              let
                ( newModel, cmd ) = LetterPicker.update wgMsg store.eLetterPicker
                log = Debug.log "pick" wgMsg
              in
                { store | eLetterPicker = newModel } ! [ Cmd.map (LetterPickerMsg "uid") cmd ]



-- DATA

type alias Store =
    { eLetterPicker: LetterPicker.Model
    , eSearchBox: SearchBox.Model
    , letter: String
    , rows: Ports.Rows
    }

initStore : Store
initStore =
  { eLetterPicker = LetterPicker.initialModel
  , eSearchBox = SearchBox.initialModel
  , letter = "a"
  , rows = []
  }

-- VIEW
link : String -> Html msg
link href =
    node "link"
        [ Attr.rel "stylesheet"
        , Attr.href href
        ]
        []


view : Store -> Html Msg
view store =
  let
    renderItem row = node "li" []
      [ node "word" [] [text row.word]
      , node "def" [property "innerHTML" (Json.string row.definition)] []
      ]
  in
    div []
      [ link "/dist/style.css"
      -- , text ("Store: " ++ toString store)
      , div [] [ App.map (LetterPickerMsg "uid") (LetterPicker.render store.eLetterPicker) ]
      , div [] [ App.map (SearchBoxMsg "uid") (SearchBox.render store.eSearchBox) ]
      , div [ Attr.class "items" ] [node "ul" [] (List.map renderItem store.rows)]
      ]
