module Model exposing (Form, Message, Model, Name, Problem, Record, Status(..), init)

import List exposing (singleton)



-- MODEL


type alias Name =
    String


type alias Message =
    String


type alias Form =
    { name : Name
    , message : Message
    }


type alias Problem =
    String


type Status
    = Loading
    | Loaded
    | Failed


type alias Model =
    { form : Form
    , history : List Form
    , problems : List Problem
    , status : Status
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
    , status = Loading
    }
