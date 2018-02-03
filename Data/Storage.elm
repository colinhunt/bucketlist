port module Data.Storage exposing (savePrSettings, loadPrSettings, onLoad)

import Json.Encode exposing (Value)
import Data.Types exposing (..)
import Data.Encoders as Encode
import Model.Model exposing (PullRequestSettings)


savePrSettings : PullRequestSettings -> Cmd msg
savePrSettings settings =
    let
        key =
            prSettingsKey settings.prId
    in
        save <| Encode.keyedValue key (Encode.pullRequestSettings settings)


loadPrSettings : List StorageKey -> Cmd msg
loadPrSettings keys =
    load (List.map keyToString keys)


port save : Value -> Cmd msg


port load : List String -> Cmd msg


port onLoad : (Value -> msg) -> Sub msg
