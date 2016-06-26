port module Ports exposing (..)
-- Ports

type alias Row =
  { word : String
  , definition : String
  }

type alias Rows = List Row

port letterChange : String -> Cmd msg
port wordChange : String -> Cmd msg

port setRows : (Rows -> msg) -> Sub msg
