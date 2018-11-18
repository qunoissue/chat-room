port module Ports exposing (getLocalStorage, getName, postMessage, receiveLocalStorage, receiveMessage, saveName, setLocalStorage)

import Json.Encode exposing (Value)



-- Incoming messages


port receiveMessage : (Value -> msg) -> Sub msg


port receiveLocalStorage : (Value -> msg) -> Sub msg



-- Outgoing messages


port postMessage : Value -> Cmd msg


port setLocalStorage : ( String, String ) -> Cmd msg


saveName : String -> Cmd msg
saveName name =
    setLocalStorage ( "name", name )


port getLocalStorage : String -> Cmd msg


getName : () -> Cmd msg
getName _ =
    getLocalStorage "name"
