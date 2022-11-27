
import QtQuick 2.8
import QtQuick.Window 2.0
import QtMultimedia 5.15
import "components"
import "./js/utils.mjs" as Utils

FocusScope {
  id: root

  readonly property var vpx: Utils.vpx(Screen.height)
  readonly property var delay: Utils.delay(root)
  readonly property var setAvailableActions: buttonActions.setAvailableActions
  readonly property var appendAdditionalAvailableActions: buttonActions.appendAdditionalAvailableActions
  readonly property var navigate: router.navigate

  SoundEffect {
    id: channelUpSound
    source: "assets/audio/channel-up.wav"
    volume: .5
  }

  SoundEffect {
    id: channelDownSound
    source: "assets/audio/channel-down.wav"
    volume: .5
  }

  SoundEffect {
    id: panelLeftSound
    source: "assets/audio/panel-left.wav"
    volume: .1
  }

  SoundEffect {
    id: panelRightSound
    source: "assets/audio/panel-right.wav"
    volume: .1
  }

  SoundEffect {
    id: panelUnfoldSound
    source: "assets/audio/panel-unfold.wav"
    volume: .01
  }

  SoundEffect {
    id: selectSound
    source: "assets/audio/select.wav"
    volume: .5
  }

  SoundEffect {
    id: focusSound
    source: "assets/audio/focus.wav"
    volume: .5
  }

  SoundEffect {
    id: backSound
    source: "assets/audio/back.wav"
    volume: .5
  }

  Background {
    wallpaperName: "2"
  }

  Stage {
    id: stage
    stageName: "0003"
  }

  Router {
    id: router
    focus: true
    anchors.fill: parent
  }

  ButtonActions {
    id: buttonActions
  }

  Keys.onPressed: {
    buttonActions.onPressed(event);
  }
}
