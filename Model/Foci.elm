module Model.Foci exposing (..)

import Model.Model exposing (..)
import Lib exposing (..)


baseUrl =
    recordFocus .baseUrl (\r v -> { r | baseUrl = v })


username =
    recordFocus .username (\r v -> { r | username = v })


password =
    recordFocus .password (\r v -> { r | password = v })


authStatus =
    recordFocus .authStatus (\r v -> { r | authStatus = v })


timeNow =
    recordFocus .timeNow (\r v -> { r | timeNow = v })


pullRequests =
    recordFocus .pullRequests (\r v -> { r | pullRequests = v })


id =
    recordFocus .id (\r v -> { r | id = v })


author =
    recordFocus .author (\r v -> { r | author = v })


targetBranch =
    recordFocus .targetBranch (\r v -> { r | targetBranch = v })


repo =
    recordFocus .repo (\r v -> { r | repo = v })


title =
    recordFocus .title (\r v -> { r | title = v })


numCommenters =
    recordFocus .numCommenters (\r v -> { r | numCommenters = v })


link =
    recordFocus .link (\r v -> { r | link = v })


createdTime =
    recordFocus .createdTime (\r v -> { r | createdTime = v })


settings =
    recordFocus .settings (\r v -> { r | settings = v })


dismissed =
    recordFocus .dismissed (\r v -> { r | dismissed = v })


pullRequest id =
    listFocus
        (.id >> (==) id)
        nullPullRequest
