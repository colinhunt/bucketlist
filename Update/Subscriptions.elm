module Update.Subscriptions exposing (..)

import Data.Storage
import Model.Model exposing (Model, Msg(..))
import Update.Update as Update


subscriptions : Model -> Sub Msg
subscriptions model =
    Data.Storage.onLoad (Fun << Update.onLoad)
