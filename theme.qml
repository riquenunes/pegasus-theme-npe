
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

  Image {
    source: 'assets/images/wallpapers/2.png'
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Image {
    id: stage
    source: 'assets/images/stages/0003.png'
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
    opacity: 0
    anchors.topMargin: vpx(30)

    states: [
      State { name: 'Visible'; when: enabled },
      State { name: 'Invisible'; when: !enabled }
    ]

    transitions: [
      Transition {
        to: 'Visible'
        ParallelAnimation {
          NumberAnimation {
            target: stage
            property: 'anchors.topMargin'
            to: 0
            duration: 100
          }
          NumberAnimation {
            target: stage
            property: 'opacity'
            to: 1
            duration: 200
          }
        }
      },
      Transition {
        to: 'Invisible'
        ParallelAnimation {
          NumberAnimation {
            target: stage
            property: 'anchors.topMargin'
            to: vpx(30)
            duration: 100
          }
          NumberAnimation {
            target: stage
            property: 'opacity'
            to: 0
            duration: 200
          }
        }
      }
    ]
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
    'generic': 'generic',
    'steam': 'steam'
  }

  function getChannelsPanelStyle(channelItems) {
    const channelItemsArray = channelItems.toVarArray();

    if (channelItemsArray.some(g => g.assets.poster)) {
      return panelStyle.cover;
    } else if (channelItemsArray.some(g => g.assets.steam)) {
      return panelStyle.steam;
    }

    return panelStyle.generic;
  }

  function getChannelsPanelDimensions(channelItems, style) {
    const map = {
      [panelStyle.cover]: {
        width: vpx(234),
        height: vpx(320)
      },
      [panelStyle.generic]: {
        width: vpx(420),
        height: vpx(320)
      },
      [panelStyle.steam]: {
        width: vpx(460),
        height: vpx(215)
      }
    }

    return map[style];
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


  function navigate(page, params) {
    api.memory.set(memoryKeys.page, page);

    if (params) {
      const key = Object.keys(params)[0];
      const value = params[key];

      api.memory.set(key, value);
    }

    delay(() => {
      stage.state = page.showStage ? 'Visible' : 'Invisible';
      pageLoader.source = `pages/${page.path}`;
    }, 240); // delay page change until button press animation and sound is complete
             // if actions to be executed by the buttons are moved to ButtonPrompt
             // we can implement this there
  }

  property var memoryKeys: {
    'page': 'page',
    'currentGame': 'current-game',
    'videoPath': 'video-path',
    'imagePaths': 'image-paths',
    'libraryChannelIndex': 'library.channel-index',
    'libraryPanelIndex': 'library.panel-index',
    'gameDetailsPanelIndex': 'game-details.panel-index'
  }

  property var pages: {
    'library': {
      path: 'LibraryPage.qml',
      showStage: true
    },
    'gameDetails': {
      path: 'DetailsPage.qml',
      showStage: false
    },
    'videoPlayer': {
      path: 'VideoPlayerPage.qml',
      showStage: false
    },
    'imageViewer': {
      path: 'ImageViewerPage.qml',
      showStage: false
    }
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
    id: panelUnfoldSound
    source: 'assets/audio/panel-unfold.wav'
    volume: .01
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
    asynchronous: true
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
