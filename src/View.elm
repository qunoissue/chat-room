module View exposing (view)

import Browser exposing (Document, document)
import Css exposing (Css, class)
import Dialog
import Html exposing (..)
import Html.Attributes as At exposing (class, disabled, placeholder, style, type_, value, wrap)
import Html.Events exposing (on, onClick, onInput, onSubmit)
import Json.Decode as D
import List exposing (map)
import Model exposing (..)
import Update exposing (Msg(..))



-- VIEW


view : Model -> Document Msg
view model =
    { title = "ChatRoom"
    , body =
        [ viewDialog model
        , div
            [ Css.class Css.App "main"
            ]
            [ div
                [ Css.class Css.App "history"
                , At.id "history"
                ]
              <|
                case model.status of
                    Loading ->
                        [ div [ Css.class Css.Loader "loader" ]
                            [ div
                                [ Css.class Css.Loader "ball-clip-rotate" ]
                                [ div [] [] ]
                            ]
                        ]

                    Loaded ->
                        map (viewHistory model.name) model.history

                    Failed ->
                        []
            , div [ Css.class Css.App "footer" ]
                [ label [] [ text model.name ]
                , viewForm model.message
                ]
            ]
        ]
    }


viewDialog : Model -> Html Msg
viewDialog model =
    Dialog.view
        (if model.showDialog then
            Just
                { closeMessage = Just DecideName
                , containerClass = Nothing
                , header = Nothing
                , body =
                    Just
                        (div []
                            [ text "Enter your name."
                            , viewNameInput model.name
                            ]
                        )
                , footer =
                    Just
                        (button
                            [ class "btn btn-success"
                            , onClick DecideName
                            ]
                            [ text "OK" ]
                        )
                }

         else
            Nothing
        )


viewNameInput : Name -> Html Msg
viewNameInput name =
    Html.form [ onSubmit DecideName ]
        [ input [ placeholder "Name", value name, onInput ChangeName ] []
        ]


viewForm : Message -> Html Msg
viewForm message =
    Html.form [ onSubmit Submit ]
        [ textarea [ placeholder "Message", wrap "hard", value message, onInput ChangeMessage ] []
        , button
            [ class "btn btn-success"
            , Css.class Css.Form "button"
            , disabled <| String.isEmpty <| String.trim message
            ]
            [ text "send" ]
        ]


viewHistory : Name -> Talk -> Html msg
viewHistory name talk =
    let
        messageClass =
            if talk.name == name then
                "self"

            else
                "others"
    in
    div [ Css.class Css.Talk messageClass ]
        [ label []
            [ text talk.name ]
        , div []
            [ p [] <|
                viewMultiLine talk.message
            ]
        ]


viewMultiLine : Message -> List (Html msg)
viewMultiLine message =
    List.intersperse
        (br [] [])
        (map text <| String.split "\n" message)
