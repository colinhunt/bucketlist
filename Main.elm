module Main exposing (..)

import Html
import Update.Update exposing (update)
import Update.Subscriptions exposing (subscriptions)
import Model.Model exposing (Model, Msg, initModel)
import View.View exposing (view)


main =
    Html.program
        { init = initModel ! []
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
