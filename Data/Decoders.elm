module Data.Decoders exposing (..)

import Dict
import Json.Decode exposing (..)
import Model.Model exposing (PullRequest, PullRequestSettings)


pullRequests : Decoder (List PullRequest)
pullRequests =
    at [ "values" ] <|
        list pullRequest


pullRequest : Decoder PullRequest
pullRequest =
    let
        makePullRequest id title createdDate repo toRef author link =
            { id = id
            , author = author
            , targetBranch = toRef
            , repo = repo
            , title = title
            , numCommenters = -1
            , link = link
            , createdTime = createdDate
            , settings = { prId = id, dismissed = False }
            }
    in
        map7 makePullRequest
            (field "id" int)
            (field "title" string)
            (field "createdDate" float)
            (at [ "fromRef", "repository", "name" ] string)
            (at [ "toRef", "displayId" ] string)
            (at [ "author", "user", "slug" ] string)
            (at [ "links", "self" ] <| index 0 <| field "href" string)


pullRequestSettings : Decoder PullRequestSettings
pullRequestSettings =
    map2 PullRequestSettings
        (field "prId" int)
        (field "dismissed" bool)


storageResult : Decoder (Dict.Dict String Value)
storageResult =
    dict value
