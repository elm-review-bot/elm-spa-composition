module TicToc exposing (initPageWidget)

-- local imports

import Html exposing (Html)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import Time
import Page exposing (Update, Subscription, View, PageWidget)


type alias Model =
    { interval : Float
    , state : Bool
    , enabled : Bool
    }


type Msg
    = Toggle
    | Tick


init : Float -> flags -> ( Model, Cmd Msg )
init i _ =
    ( { interval = i
      , state = True
      , enabled = True
      }
    , Cmd.none
    )


view : View Model Msg
view m =
    Html.span []
        [ Html.input
            [ type_ "checkbox"
            , checked m.enabled
            , onClick Toggle
            ]
            []
        , Html.code []
            [ Html.text <|
                if m.state then
                    "Tic"

                else
                    "Toc"
            ]
        ]


update : Update Model Msg
update msg model =
    ( case msg of
        Toggle ->
            { model | enabled = not model.enabled }

        Tick ->
            { model | state = not model.state }
    , Cmd.none
    )


sub : Subscription Model Msg
sub model =
    if model.enabled then
        Time.every model.interval (always Tick)

    else
        Sub.none

initPageWidget : Float -> PageWidget Model Msg ()
initPageWidget float =
    { init = init float
    , update = update
    , view = view
    , subscriptions = sub
    }