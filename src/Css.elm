module Css exposing
    ( Css(..)
    , class
    , classList
    )

import Html exposing (Attribute)
import Html.Attributes as Attributes


type Css
    = App
    | Form
    | Loader
    | Talk


cssPrefix : Css -> String
cssPrefix css =
    case css of
        App ->
            "app__"

        Form ->
            "form__"

        Loader ->
            "loader__"

        Talk ->
            "talk__"


className : Css -> String -> String
className css name =
    cssPrefix css ++ name


class : Css -> String -> Attribute msg
class css name =
    Attributes.class <| className css name


classList : Css -> List ( String, Bool ) -> Attribute msg
classList css list =
    Attributes.classList <|
        List.map (Tuple.mapFirst (className css)) list
