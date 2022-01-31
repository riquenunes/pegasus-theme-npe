
import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import QtMultimedia 5.15
import 'pages'
import 'components'

FocusScope {
  id: root

  Keys.onPressed: {
    buttonActions.onPressed(event);
  }

  property var actionKeys: {
    'bottom': 'a',
    'right': 'b',
    'left': 'x',
    'top': 'y'
  }

  property var availableActions: {
    'a': { visible: true },
    'b': { visible: true },
    'x': { visible: true },
    'y': { visible: true }
  }

  function setAvailableActions(replacementActions) {
    const newActions = Object.values(actionKeys).reduce((newActions, key) => {
      if (replacementActions[key]) {
        newActions[key] = replacementActions[key];
      } else {
        newActions[key] = {
          visible: false,
          label: availableActions[key] ? availableActions[key].label : undefined
        };
      }

      return newActions;
    }, {})

    availableActions = newActions;
  }


  function vpx(size) {
    return Math.round(size * (Screen.height / 720))
  }

  property var panelStyle: {
    'cover': 'cover',
    'generic': 'generic'
  }

  function getChannelsPanelStyle(channelItems) {
    if (channelItems.toVarArray().some(g => g.assets.poster)) {
      return panelStyle.cover;
    }

    return panelStyle.generic;
  }

  function getChannelsPanelDimensions(channelItems) {
    const style = getChannelsPanelStyle(channelItems);
    const map = {
      [panelStyle.cover]: {
        width: vpx(234),
        height: vpx(320)
      },
      [panelStyle.generic]: {
        width: vpx(420),
        height: vpx(320)
      }
    }

    return map[style];
  }


  function navigate(page, params) {
    api.memory.set(memoryKeys.page, page);

    if (params) {
      const key = Object.keys(params)[0];
      const value = params[key];

      api.memory.set(key, value);
    }

    function delay(cb, delayTime) {
      function Timer() {
        return Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
      }

      const timer = new Timer();
      timer.interval = delayTime;
      timer.repeat = false;
      timer.triggered.connect(cb);
      timer.start();
    }

    delay(() => {
      pageLoader.source = `pages/${page}`;
    }, 240); // delay page change until button press animation and sound is complete
             // if actions to be executed by the buttons are moved to ButtonPrompt
             // we can implement this there
  }

  property var memoryKeys: {
    'page': 'page',
    'currentGame': 'current-game',
    'videoPath': 'video-path',
    'imagePaths': 'image-paths'
  }

  property var pages: {
    'library': 'LibraryPage.qml',
    'gameDetails': 'DetailsPage.qml',
    'videoPlayer': 'VideoPlayerPage.qml',
    'imageViewer': 'ImageViewerPage.qml'
  }

  SoundEffect {
    id: channelUpSound
    source: 'assets/audio/channel-up.wav'
    volume: .5
  }

  SoundEffect {
    id: channelDownSound
    source: 'assets/audio/channel-down.wav'
    volume: .5
  }

  SoundEffect {
    id: panelLeftSound
    source: 'assets/audio/panel-left.wav'
    volume: .1
  }

  SoundEffect {
    id: panelRightSound
    source: 'assets/audio/panel-right.wav'
    volume: .1
  }

  SoundEffect {
    id: selectSound
    source: 'assets/audio/select.wav'
    volume: .5
  }

  SoundEffect {
    id: focusSound
    source: 'assets/audio/focus.wav'
    volume: .5
  }

  SoundEffect {
    id: backSound
    source: 'assets/audio/back.wav'
    volume: .5
  }

  Loader {
    id: pageLoader
    focus: true
    anchors.fill: parent
  }

  ButtonActions {
    id: buttonActions
  }

  Component.onCompleted: {
    if (!api.memory.has(memoryKeys.page)) {
      navigate(pages.library);
    } else {
      navigate(api.memory.get(memoryKeys.page));
    }
  }
}
