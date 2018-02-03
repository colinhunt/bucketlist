module Update.Update exposing (..)

import Http
import Task
import Time
import Dict
import Json.Decode
import RemoteData
import Data.Storage
import Data.Types
import Focus exposing (..)
import Model.Model exposing (..)
import Data.Decoders as Decoders
import Utils exposing (..)
import Model.Foci as F


type alias Updater =
    Model -> ( Model, Cmd Msg )


update : Msg -> Updater
update (Fun f) model =
    f model


onChangeUserName : String -> Updater
onChangeUserName username model =
    { model | username = username } ! []


onChangePassword : String -> Updater
onChangePassword password model =
    { model | password = password } ! []


onSaveCreds : Updater
onSaveCreds model =
    { model | authStatus = AuthNotTried } ! [ getPullRequests model ]


onChangeCreds : Updater
onChangeCreds model =
    { model | authStatus = AuthNotSaved } ! []


onGetPullRequests : ( RemoteData.WebData (List PullRequest), Time.Time ) -> Updater
onGetPullRequests ( result, time ) model =
    case result of
        RemoteData.Success pullRequests ->
            { model
                | pullRequests = pullRequests
                , pullRequestsStatus = RemoteData.Success []
                , authStatus = AuthSuccess
                , timeNow = time
            }
                ! [ loadPrSettings pullRequests ]

        RemoteData.Failure (Http.BadUrl _) ->
            { model
                | pullRequestsStatus = result
                , authStatus = AuthFailed
                , timeNow = time
            }
                ! []

        RemoteData.Failure (Http.BadStatus response) ->
            { model
                | pullRequestsStatus = result
                , authStatus =
                    authStatusFromCode response.status.code model.authStatus
                , timeNow = time
            }
                ! []

        _ ->
            { model
                | pullRequestsStatus = result
                , timeNow = time
            }
                ! []


onPrDismiss : PullRequestSettings -> Bool -> Updater
onPrDismiss current dismissed model =
    let
        newSettings =
            { current | dismissed = dismissed }
    in
        set
            (F.pullRequests => (F.pullRequest current.prId) => F.settings)
            newSettings
            model
            ! [ storePrSettings newSettings ]


getPullRequests : Model -> Cmd Msg
getPullRequests model =
    Task.perform
        (Fun << onGetPullRequests)
        (Task.map2
            (\prs time -> ( prs, time ))
            (loadAuthenticated
                Decoders.pullRequests
                "/dashboard/pull-requests"
                model
            )
            (Time.now)
        )


loadPrSettings : List PullRequest -> Cmd Msg
loadPrSettings pullRequests =
    pullRequests
        |> List.map (.id >> Data.Types.prSettingsKey)
        |> Data.Storage.loadPrSettings


storePrSettings : PullRequestSettings -> Cmd Msg
storePrSettings settings =
    Data.Storage.savePrSettings settings


onLoad : Json.Decode.Value -> Updater
onLoad json model =
    let
        dict =
            Json.Decode.decodeValue Decoders.storageResult json
                |> Result.withDefault Dict.empty

        mbKey =
            List.head <| Dict.keys dict

        values =
            Dict.values dict
    in
        case mbKey of
            Just key ->
                dispatchStorageLoader key values model

            Nothing ->
                model ! []


dispatchStorageLoader : String -> List Json.Decode.Value -> Updater
dispatchStorageLoader key values model =
    if String.startsWith "pr-settings/" key then
        onLoadPrSettings values model
    else
        model ! []


onLoadPrSettings : List Json.Decode.Value -> Updater
onLoadPrSettings values model =
    let
        prSettingsList =
            List.filterMap
                ((Json.Decode.decodeValue
                    Decoders.pullRequestSettings
                 )
                    >> Result.toMaybe
                )
                values

        prSettingsDict =
            Dict.fromList <| List.map (\s -> ( s.prId, s )) prSettingsList

        updatedPrs =
            model.pullRequests
                |> (List.map
                        (\pr ->
                            { pr
                                | settings =
                                    Dict.get pr.id prSettingsDict
                                        |> Maybe.withDefault pr.settings
                            }
                        )
                   )
    in
        { model | pullRequests = updatedPrs } ! []


authStatusFromCode code currentStatus =
    if code >= 500 then
        currentStatus
    else if code == 401 || code == 403 then
        AuthFailed
    else if code >= 200 then
        AuthSuccess
    else
        currentStatus
