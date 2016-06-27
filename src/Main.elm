module Main exposing (..)

import Html.App as App
import Html exposing (Html, node, div, text)
import Html.Attributes as Attr
import Array exposing (Array)
import Ports exposing (..)
import VirtualDom exposing (property, Property)

import LetterPicker
import SearchBox
import ItemList


main : Program Never
main =
    App.program
        { init = initStore ! []
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- INTERACTIVITY

type Msg = LetterPickerMsg String LetterPicker.Msg
        | SearchBoxMsg String SearchBox.Msg
        | WordListMsg String ItemList.Msg
        | SetRows (Ports.Rows)

subscriptions : Store -> Sub Msg
subscriptions store =
  Ports.setRows SetRows

update : Msg -> Store -> ( Store, Cmd Msg )
update msg store =
    let
      log = Debug.log "msg" "nothing"
    in
    case msg of
        SetRows rows ->
            { store | rows = rows, eWordList = {items = rows} } ! []
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

        WordListMsg uid wgMsg ->
            store ! []

-- DATA

type alias Store =
    { eLetterPicker: LetterPicker.Model
    , eSearchBox: SearchBox.Model
    , eWordList: ItemList.Model
    , letter: String
    , rows: Ports.Rows
    }

initStore : Store
initStore =
  { eLetterPicker = LetterPicker.initialModel
  , eSearchBox = SearchBox.initialModel
  , eWordList = ItemList.initialModel
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
    div [ Attr.class "mdl-layout mdl-js-layout mdl-layout--fixed-header"]
      -- , text ("Store: " ++ toString store)
      [ node "header" [ Attr.class "mdl-layout__header mdl-layout__header--scroll mdl-color--primary" ]
        [ div [ Attr.class "mdl-layout--large-screen-only mdl-layout__header-row" ] []
        , div [ Attr.class "mdl-layout--large-screen-only mdl-layout__header-row" ]
          [ Html.h3 [] [(text "Maori Dictionary")]
          ]
        , div [ Attr.class "mdl-layout--large-screen-only mdl-layout__header-row" ] []
        , div [ Attr.class "mdl-layout__tab-bar mdl-js-ripple-effect mdl-color--primary-dark" ]
          [ div [ Attr.class "controls" ]
            [ div [ Attr.class "picker" ] [ App.map (LetterPickerMsg "uid") (LetterPicker.render store.eLetterPicker) ]
            , div [ Attr.class "middle" ] [ App.map (SearchBoxMsg "uid") (SearchBox.render store.eSearchBox) ]
            ]
          ]
        ]
      , node "main" [ Attr.class "words mdl-layout__content" ]
        [ div [ Attr.class "mdl-layout__tab-panel is-active" ]
          [ div [] [ App.map (WordListMsg "uid") (ItemList.render store.eWordList) ]
          ]
        ]
      , node "footer" [ Attr.class "mdl-mega-footer" ]
        [ div [ ]
          [ text "Click on any letter to start. "
          , text "Made with "
          , node "a" [ Attr.href "http://elm-lang.org/", Attr.target "new" ] [ text "elm" ]
          , text ". Fork on github "
          , node "a" [ Attr.href "https://github.com/widged/elm-maori-dictionary", Attr.target "new" ] [ text "elm-maori-dictionary" ]
          ]
        ]
      ]
