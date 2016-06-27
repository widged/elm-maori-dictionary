module ItemList exposing (Model, render, Msg, initialModel)

import Html exposing (Html, node, div, ul, text, button, input)
import Html.Attributes as Attr
import Json.Encode as Json


type Msg = NoOp

type alias Item =
  { word : String , definition : String }

type alias Model =
  { items: List Item
  }

initialModel : Model
initialModel =
  { items = []
  }


renderItem row = node "item" []
  [ node "section" [ Attr.class "section--center mdl-grid mdl-grid--no-spacing mdl-shadow--2dp" ]
    [ div [ Attr.class "mdl-card mdl-cell mdl-cell--12-col" ]
      [ div [ Attr.class "mdl-card__supporting-text" ]
        [ Html.h1 [] [ text row.word ]
        , node "def" [Attr.property "innerHTML" (Json.string row.definition)] []
        ]

      ]
    ]
  ]

render : Model -> Html Msg
render model =
    node "item-list" [] (List.map renderItem model.items)
