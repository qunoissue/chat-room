module Model exposing (Item, Message, Model, Name, Problem(..), Status(..), Talk, init)

import Json.Decode exposing (Error)
import List exposing (singleton)



-- MODEL


type alias Name =
    String


type alias Message =
    String


type alias Talk =
    { name : Name
    , message : Message
    }


type Problem
    = MessageEmpty
    | DecodeError Error


type Status
    = Loading
    | Loaded
    | Failed


type alias Model =
    { name : Name
    , message : Message
    , history : List Talk
    , problems : List Problem
    , showDialog : Bool
    , status : Status
    }


type alias Item =
    { key : String
    , value : String
    }


init : Model
init =
    { name = ""
    , message = ""
    , history = []
    , problems = []
    , showDialog = False
    , status = Loading
    }
