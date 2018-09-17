module View exposing (..)

import Browser exposing (Document, document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)
import List exposing (map)

import Model exposing (Form, Model, Problem)
import Update exposing (Msg(..))

-- VIEW

view : Model -> Document Msg
view model =
  { title = "ChatRoom"
  , body =
      [ div []
          [ div [] (map viewHistory model.history)
          , viewForm model.form
          , ul []
              (map viewError model.problems)
          ]
      ]
  }


viewForm : Form -> Html Msg
viewForm form =
  Html.form [ onSubmit Submit ]
    [ fieldset []
        [ viewInput "text" "Name" form.name ChangeName
        , viewInput "text" "Message" form.message ChangeMessage
        , button [] [ text "send" ]
        ]
    ]


viewHistory : Form -> Html msg
viewHistory form =
  div []
    [ text (form.name ++ " : " ++ form.message) ]


viewInput : String -> String -> String -> (String -> msg) ->Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewError : Problem -> Html msg
viewError problem =
      li [ style "color" "red" ] [ text problem ]
