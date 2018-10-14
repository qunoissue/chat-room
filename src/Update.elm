port module Update exposing (Msg(..), decode, formDecoder, newMessage, postMessage, recordDecoder, subscriptions, update)

import Json.Decode as D exposing (Decoder, Error, decodeString, decodeValue, errorToString, field, map2, string)
import Json.Encode as E exposing (Value, object, string)
import List exposing (append)
import Model exposing (..)
import Validate exposing (validate)



-- Incoming messages


port newMessage : (Value -> msg) -> Sub msg



-- Outgoing messages


port postMessage : Value -> Cmd msg



-- UPDATE


type Msg
    = ChangeName Name
    | ChangeMessage Message
    | Submit
    | Changed Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeName name ->
            ( { model | form = { name = name, message = model.form.message } }
            , Cmd.none
            )

        ChangeMessage message ->
            ( { model | form = { name = model.form.name, message = message } }
            , Cmd.none
            )

        Submit ->
            case validate model.form of
                Ok form ->
                    ( { model
                        | form = { name = model.form.name, message = "" }
                        , history = model.history
                        , problems = []
                      }
                    , postMessage
                        (object
                            [ ( "name", E.string model.form.name )
                            , ( "message", E.string model.form.message )
                            ]
                        )
                    )

                Err problems ->
                    ( { model | problems = problems }
                    , Cmd.none
                    )

        Changed value ->
            case decode value of
                Ok form ->
                    ( { model
                        | history =
                            append
                                model.history
                                [ form ]
                        , status = Loaded
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( { model
                        | problems =
                            append
                                model.problems
                                [ errorToString error ]
                        , status = Failed
                      }
                    , Cmd.none
                    )


decode : Value -> Result Error Form
decode value =
    case decodeValue recordDecoder value of
        Ok record ->
            decodeString formDecoder record.val

        Err error ->
            Err error


formDecoder : Decoder Form
formDecoder =
    map2 Form
        (field "name" D.string)
        (field "message" D.string)


recordDecoder : Decoder Record
recordDecoder =
    map2 Record
        (field "id" D.string)
        (field "value" D.string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    newMessage Changed
