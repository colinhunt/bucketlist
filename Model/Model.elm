module Model.Model exposing (..)

import Time
import RemoteData
import FocusUtils exposing (..)


type Msg
    = Fun (Model -> ( Model, Cmd Msg ))


type alias Model =
    { baseUrl : String
    , username : String
    , password : String
    , authStatus : AuthStatus
    , timeNow : Time.Time
    , pullRequests : PullRequests
    , pullRequestsStatus : RemoteData.WebData PullRequests
    }


type AuthStatus
    = AuthNotSaved
    | AuthNotTried
    | AuthFailed
    | AuthSuccess


type alias PullRequest =
    { id : Int
    , author : String
    , targetBranch : String
    , repo : String
    , title : String
    , numCommenters : Int
    , link : String
    , createdTime : Time.Time
    , settings : PullRequestSettings
    }


nullPullRequest =
    { id = -1
    , author = ""
    , targetBranch = ""
    , repo = ""
    , title = ""
    , numCommenters = -1
    , link = ""
    , createdTime = -1
    , settings = nullPullRequestSettings
    }


type alias PullRequestSettings =
    { prId : Int
    , dismissed : Bool
    }


nullPullRequestSettings =
    { prId = -1
    , dismissed = False
    }


type alias PullRequests =
    List PullRequest


initModel =
    { baseUrl = "https://git.int.pason.com/rest/api/1.0"
    , username = "chunt"
    , password = "Bust3r12"
    , authStatus = AuthNotSaved
    , timeNow = (1513483930 * Time.second |> Time.inMilliseconds)
    , pullRequests = []
    , pullRequestsStatus = RemoteData.NotAsked
    }


enterCreds { username, password, authStatus } =
    String.isEmpty username || String.isEmpty password || authStatus == AuthNotSaved
