module View.Stylesheet exposing (..)

import Color
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
import Style.Shadow as Shadow


type Styles
    = None
    | Page
    | Navbar
    | Field
    | Button
    | LabelBox
    | Form
    | Link
    | Pr PullRequestStyles


type Variations
    = Dismissed


type PullRequestStyles
    = List
    | Header
    | PullRequestStyle
    | Info
    | Title
    | Target


primaryColor =
    Color.rgb 245 255 250


accentColor =
    Color.rgb 95 158 160


lightAccentColor =
    Color.rgb 133 187 189


shadow =
    { blur = 5
    , color = Color.rgba 0 0 0 0.3
    , offset = ( 0, 4 )
    , size = 0
    }


softShadow =
    { offset = ( 0, 10 )
    , size = 0
    , blur = 20
    , color = Color.rgba 0 0 0 0.2
    }


stylesheet : StyleSheet Styles Variations
stylesheet =
    Style.styleSheet
        [ style None [] -- blank style
        , style Page
            [ Color.text Color.darkCharcoal
            , Font.typeface
                [ Font.font "helvetica"
                , Font.font "arial"
                , Font.font "sans-serif"
                ]
            , Font.size 16
            , Font.lineHeight 1.3
            ]
        , style Navbar []
        , style LabelBox
            []
        , style Field
            [ Border.rounded 5
            , Border.all 1
            , Border.solid
            , Color.border Color.lightGrey
            , Shadow.inset
                { offset = ( 0, 10 )
                , size = -12
                , blur = 20
                , color = Color.rgba 0 0 0 0.2
                }
            ]
        , style Button
            [ Border.rounded 5
            , Color.background lightAccentColor
            , Shadow.box shadow
            ]
        , style Form
            [ Border.rounded 10
            , Border.all 1
            , Border.solid
            , Color.border Color.lightGrey
            , Shadow.deep
            ]
        , style Link
            [ Color.text accentColor ]
        , style (Pr List)
            [ Border.rounded 15
            , Color.background <| lightAccentColor
            , Shadow.box shadow
            ]
        , style (Pr Header)
            [ Font.bold
            ]
        , style (Pr Info)
            [ Color.text Color.darkGray
            ]
        , style (Pr PullRequestStyle)
            [ Border.rounded 15
            , Color.background <| primaryColor
            , Shadow.box shadow
            , variation Dismissed [ opacity 0.5 ]
            ]
        ]
