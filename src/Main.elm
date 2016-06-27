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
            , div [ Attr.class "middle" ] [ text "hello" ]
            , div [ Attr.class "middle" ] [ App.map (SearchBoxMsg "uid") (SearchBox.render store.eSearchBox) ]
            ]
          ]
        ]
      , node "main" [ Attr.class "words mdl-layout__content" ]
        [ div [ Attr.class "mdl-layout__tab-panel is-active" ]
          [ div [] [ App.map (WordListMsg "uid") (ItemList.render store.eWordList) ]
          ]
        ]
      ]
{-
    <main class="mdl-layout__content">
      <div class="mdl-layout__tab-panel is-active" id="overview">
        <section class="section--center mdl-grid mdl-grid--no-spacing mdl-shadow--2dp">
          <div class="mdl-card mdl-cell mdl-cell--12-col">
            <div class="mdl-card__supporting-text">
              <h4>Technology</h4>
              Dolore ex deserunt aute fugiat aute nulla ea sunt aliqua nisi cupidatat eu. Nostrud in laboris labore nisi amet do dolor eu fugiat consectetur elit cillum esse. Pariatur occaecat nisi laboris tempor laboris eiusmod qui id Lorem esse commodo in. Exercitation aute dolore deserunt culpa consequat elit labore incididunt elit anim.
            </div>
          </div>
          <button class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--icon" id="btn3">
            <i class="material-icons">more_vert</i>
          </button>
          <ul class="mdl-menu mdl-js-menu mdl-menu--bottom-right" for="btn3">
            <li class="mdl-menu__item">Lorem</li>
          </ul>
        </section>
        <section></section>
      </div>
      <footer class="mdl-mega-footer">
        <div class="mdl-mega-footer--bottom-section">
          <div class="mdl-logo">
            More Information
          </div>
          <ul class="mdl-mega-footer--link-list">
            <li><a href="https://developers.google.com/web/starter-kit/">Web Starter Kit</a></li>
            <li><a href="#">Help</a></li>
            <li><a href="#">Privacy and Terms</a></li>
          </ul>
        </div>
      </footer>
    </main>
  </div>
-}
