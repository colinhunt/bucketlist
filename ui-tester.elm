module UiTester exposing (..)

import Html
import Time
import RemoteData
import View.View as View
import Model.Model exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Element.Input as Input
import View.Stylesheet exposing (..)


main =
    Html.beginnerProgram
        { view = view
        , model = model
        , update = update
        }


model : Model
model =
    { baseUrl = ""
    , username = "jlpicard"
    , password = "make-it-so"
    , authStatus = AuthSuccess
    , timeNow = timeNow
    , pullRequests = mockPullRequests
    , pullRequestsStatus = RemoteData.Success []
    }


timeNow =
    1513483930 * Time.second


mockPullRequests =
    [ PullRequest
        1
        "chunt"
        "master"
        "Well Download Service"
        "LWEB-1205: I want the basic ability to Provide LAS Export from WDS (Phase 1)"
        3
        "http://git.int.pason.com/wds"
        ((timeNow)
            - (1.5 * Time.hour)
        )
        (PullRequestSettings
            1
            True
        )
    , PullRequest
        2
        "tyee"
        "LWEB-1205"
        "Live Rig View Web"
        "LWEB-1234: Branched off of 1205"
        12
        "git.int.pason.com/wds"
        ((timeNow)
            - (20 * Time.hour)
        )
        (PullRequestSettings
            2
            False
        )
    , PullRequest
        3
        "tschellenberg"
        "master"
        "Drilling Data Read Service"
        "LWEB-1885: Here is a really long title that will go on forever and maybe wrap somewhere but not sure and how many times who knows haha"
        101
        "git.int.pason.com/wds"
        ((timeNow)
            - (900 * Time.hour)
        )
        (PullRequestSettings
            3
            False
        )
    ]


view : Model -> Html.Html Msg
view model =
    let
        heading txt =
            h1 None [ paddingBottom 10, paddingTop 10 ] <| text txt
    in
        Element.layout stylesheet <|
            column Page [ spacing 10 ] <|
                [ heading "Form"
                , View.credentialsForm model
                , heading "Pull Request List"
                , View.viewMain model
                ]


update : Msg -> Model -> Model
update msg model =
    model
