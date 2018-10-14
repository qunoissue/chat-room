module Validate exposing (ValidateField(..), validate, validateField)

import List exposing (concatMap)
import Model exposing (Form, Problem)
import String exposing (isEmpty)


type ValidateField
    = Name
    | Message


validate : Form -> Result (List Problem) Form
validate form =
    case concatMap (validateField form) [ Name, Message ] of
        [] ->
            Ok form

        problems ->
            Err problems


validateField : Form -> ValidateField -> List Problem
validateField form field =
    case field of
        Name ->
            if isEmpty form.name then
                [ "Name can't be blank!" ]

            else
                []

        Message ->
            if isEmpty form.message then
                [ "Message can't be blank!" ]

            else
                []
