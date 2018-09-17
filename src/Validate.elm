module Validate exposing (..)

import List exposing (concatMap)
import String exposing (isEmpty)

import Model exposing (Form, Problem)



type ValidateField
  = Name
  | Message


validate : Form -> Result (List Problem) Form
validate form =
  case concatMap (validateField form) [Name, Message] of
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
