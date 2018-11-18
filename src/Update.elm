port module Update exposing (Msg(..), decodeMessage, formDecoder, recordDecoder, subscriptions, update)

import Browser.Dom as Dom
import Json.Decode as D exposing (Decoder, Error, decodeString, decodeValue, errorToString, field, map2, string)
import Json.Encode as E exposing (Value, object, string)
import List exposing (append)
import Model exposing (..)
import Ports exposing (postMessage, receiveLocalStorage, receiveMessage, saveName)
import Random as R exposing (Generator, generate, int)
import Task exposing (attempt)



-- UPDATE


type Msg
    = ReceiveLocalStorage Value
    | NewGuestName String
    | ChangeName Name
    | DecideName
    | ChangeMessage Message
    | Submit
    | NewMessage Value
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveLocalStorage value ->
            case decodeLocalStorage value of
                Ok pair ->
                    if pair.key == "name" then
                        ( { model | name = pair.value }
                        , Cmd.none
                        )

                    else
                        ( { model | showDialog = True }, Cmd.none )

                Err _ ->
                    ( { model | showDialog = True }, Cmd.none )

        NewGuestName number ->
            ( { model | name = "Guest-" ++ number }
            , Cmd.none
            )

        ChangeName name ->
            ( { model | name = name }
            , Cmd.none
            )

        DecideName ->
            ( { model | showDialog = False }
            , Cmd.batch
                [ if String.isEmpty <| String.trim model.name then
                    generate NewGuestName generateRandomNumber3

                  else
                    Cmd.none
                , saveName model.name
                ]
            )

        ChangeMessage message ->
            ( { model | message = message }
            , Cmd.none
            )

        Submit ->
            ( { model
                | message = ""
                , history = model.history
                , problems = []
              }
            , postMessage
                (object
                    [ ( "name", E.string model.name )
                    , ( "message", E.string model.message )
                    ]
                )
            )

        NewMessage value ->
            case decodeMessage value of
                Ok form ->
                    ( { model
                        | history =
                            append
                                model.history
                                [ form ]
                        , status = Loaded
                      }
                    , jumpToBottom "history"
                    )

                Err error ->
                    ( { model
                        | problems =
                            append
                                model.problems
                                [ DecodeError error ]
                        , status = Failed
                      }
                    , Cmd.none
                    )

        NoOp ->
            ( model, Cmd.none )


jumpToBottom : String -> Cmd Msg
jumpToBottom id =
    Dom.getViewportOf id
        |> Task.andThen (\info -> Dom.setViewportOf id 0 info.scene.height)
        |> Task.attempt (\_ -> NoOp)


decodeMessage : Value -> Result Error Talk
decodeMessage value =
    case decodeValue recordDecoder value of
        Ok record ->
            decodeString formDecoder record.value

        Err error ->
            Err error


formDecoder : Decoder Talk
formDecoder =
    map2 Talk
        (field "name" D.string)
        (field "message" D.string)


recordDecoder : Decoder Item
recordDecoder =
    map2 Item
        (field "key" D.string)
        (field "value" D.string)


decodeLocalStorage : Value -> Result Error Item
decodeLocalStorage value =
    decodeValue localStorageDecoder value


localStorageDecoder : Decoder Item
localStorageDecoder =
    map2 Item
        (field "key" D.string)
        (field "value" D.string)


generateRandomNumber3 : Generator String
generateRandomNumber3 =
    R.map (String.padLeft 3 '0' << String.fromInt) <|
        int 0 999



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveMessage NewMessage
        , receiveLocalStorage ReceiveLocalStorage
        ]
