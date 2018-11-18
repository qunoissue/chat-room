module Main exposing (main)

import Browser exposing (document)
import Json.Encode exposing (Value)
import Model exposing (Model)
import Ports exposing (getName)
import Update exposing (Msg, subscriptions, update)
import View exposing (view)



-- APP


main : Program Value Model Msg
main =
    document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


init : Value -> ( Model, Cmd Msg )
init _ =
    ( Model.init
    , getName ()
    )
