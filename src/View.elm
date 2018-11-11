module View exposing (view)

import Browser exposing (Document, document)
import Css exposing (Css, class)
import Html exposing (..)
import Html.Attributes as At exposing (class, placeholder, style, type_, value)
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
        [ div
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
                        map viewHistory model.history

                    Failed ->
                        []
            , div [ Css.class Css.App "footer" ]
                [ viewForm model.form
                , ul [] <|
                    map viewError model.problems
                ]
            ]
        ]
    }


viewForm : Form -> Html Msg
viewForm form =
    Html.form [ onSubmit Submit ]
        [ input [ type_ "text", placeholder "Name", value form.name, onInput ChangeName ] []
        , input [ type_ "textarea", placeholder "Message", value form.message, onInput ChangeMessage ] []
        , button [] [ text "send" ]
        ]


viewHistory : Form -> Html msg
viewHistory form =
    let
        messageClass =
            if form.name == "Guest" then
                "message-right"

            else
                "message-left"
    in
    div [ Css.class Css.Label messageClass ]
        [ label []
            [ text form.name ]
        , div []
            [ p []
                [ text form.message ]
            ]
        ]


viewError : Problem -> Html msg
viewError problem =
    li [ Css.class Css.Label "error" ] [ text problem ]
