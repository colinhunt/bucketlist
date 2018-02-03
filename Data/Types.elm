module Data.Types exposing (StorageKey, keyToString, prSettingsKey)


type StorageKey
    = StorageKey String


keyToString : StorageKey -> String
keyToString (StorageKey key) =
    key


prSettingsKey : Int -> StorageKey
prSettingsKey id =
    StorageKey <| "pr-settings/" ++ toString id
