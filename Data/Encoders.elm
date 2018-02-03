module Data.Encoders exposing (..)

import Json.Encode exposing (..)
import Data.Types exposing (..)
import Model.Model exposing (PullRequestSettings)


(=>) : a -> b -> ( a, b )
(=>) a b =
    ( a, b )


pullRequestSettings : PullRequestSettings -> Value
pullRequestSettings settings =
    object
        [ "prId" => int settings.prId
        , "dismissed" => bool settings.dismissed
        ]


keyedValue : StorageKey -> Value -> Value
keyedValue key value =
    object
        [ keyToString key => value ]
