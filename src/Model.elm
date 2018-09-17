module Model exposing (..)

import List exposing (singleton)



-- MODEL

type alias Name = String


type alias Message = String


type alias Form =
  { name : Name
  , message : Message
  }


type alias Problem = String


type alias Model =
  { form : Form
  , history : List Form
  , problems : List Problem
  }


type alias Record =
  { id : String
  , val : String
  }


init : Model
init =
  { form =
    { name = "Guest"
    , message = ""
    }
  , history = []
  , problems = []
  }
