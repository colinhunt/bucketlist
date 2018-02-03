module View.View exposing (..)

import Html
import Html.Events
import Html.Attributes
import Time exposing (Time)
import Model.Model exposing (..)
import Update.Update exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Element.Input as Input
import Element.Keyed as Keyed
import View.Stylesheet exposing (..)
import RemoteData exposing (WebData)


type alias ESMV =
    Element Styles Variations Msg


elText txt =
    el None [] <| text txt


view : Model -> Html.Html Msg
view model =
    Element.layout stylesheet <|
        viewMain model


viewMain : Model -> ESMV
viewMain model =
    el None [ center ] <|
        column Page [] <|
            [ (when <| enterCreds model) <| credentialsModal model
            , row Navbar [ alignRight, padding 10 ] [ button1 [ onClick <| Fun onChangeCreds ] "Credentials" ]
            , viewPullRequests model.pullRequests model.timeNow
            ]


credentialsModal : Model -> ESMV
credentialsModal model =
    modal Page [ center, moveDown 200 ] <|
        credentialsForm model


button1 : List (Attribute variation msg) -> String -> Element Styles variation msg
button1 attrs label =
    button Button (attrs ++ [ padding 5 ]) <| text label


credentialsForm : Model -> ESMV
credentialsForm model =
    column Form [ width (px 200), padding 20, spacing 15 ] <|
        [ Input.username Field
            [ padding 5 ]
            { onChange = Fun << onChangeUserName
            , value = model.username
            , label = formLabel "Username:" "Bitbucket username"
            , options = []
            }
        , Input.currentPassword Field
            [ padding 5 ]
            { onChange = Fun << onChangePassword
            , value = model.password
            , label = formLabel "Password:" "Bitbucket password"
            , options = []
            }
        , button1 [ alignRight, onClick <| Fun onSaveCreds ] "save"
        ]


formLabel labelText placeholderText =
    Input.placeholder
        { label =
            Input.labelAbove <|
                el None
                    [ verticalCenter ]
                    (text labelText)
        , text = placeholderText
        }


viewPullRequests : PullRequests -> Time -> ESMV
viewPullRequests pullRequests timeNow =
    let
        authorWidth =
            width <| px 75

        infoWidth =
            width <| px 500

        numCommWidth =
            width <| px 100

        dismissWidth =
            width <| px 50

        prRowPaddingPx =
            10

        prRowSpacing =
            spacing 20

        age createdTime =
            timeNow - createdTime |> (Time.inHours >> round >> toString >> \t -> t ++ " hours")

        viewPullRequest : PullRequest -> ( String, ESMV )
        viewPullRequest pr =
            ( toString pr.id
            , row (Pr PullRequestStyle)
                [ prRowSpacing, padding prRowPaddingPx, center, verticalCenter, vary Dismissed pr.settings.dismissed ]
                [ el None [ authorWidth ] <| text pr.author
                , column (Pr Info)
                    []
                    [ el None [ infoWidth ] <| Element.link pr.link <| el Link [] <| text pr.title
                    , row None
                        [ spacing 10 ]
                        [ text pr.repo
                        , text pr.targetBranch
                        ]
                    ]
                , el None [ numCommWidth ] <|
                    el None [ center ] <|
                        text <|
                            toString pr.numCommenters
                , el None [ numCommWidth ] <| text <| age pr.createdTime
                , Input.checkbox None
                    [ dismissWidth, center ]
                    { onChange = Fun << onPrDismiss pr.settings
                    , checked = pr.settings.dismissed
                    , label = empty
                    , options = []
                    }
                ]
            )
    in
        Keyed.column (Pr List) [ alignLeft, spacing 1, padding 10 ] <|
            [ ( "header"
              , row (Pr Header)
                    [ prRowSpacing, paddingLeft prRowPaddingPx ]
                    [ el None [ authorWidth ] <| text "Author"
                    , el None [ infoWidth ] <| text "Info"
                    , el None [ numCommWidth ] <| text "Commenters"
                    , el None [ numCommWidth ] <| text "Age"
                    , el None [ dismissWidth ] <| el None [ center ] <| text "Dismiss?"
                    ]
              )
            ]
                ++ List.map viewPullRequest
                    (List.filter
                        (not << .dismissed << .settings)
                        pullRequests
                    )
                ++ [ ( "divider", el None [ padding 10 ] empty ) ]
                ++ List.map viewPullRequest
                    (List.filter
                        (.dismissed << .settings)
                        pullRequests
                    )
