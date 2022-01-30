
import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import QtMultimedia 5.15
import "pages"

FocusScope {
  id: root

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

    pageLoader.source = `pages/${page}`;
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

  Component.onCompleted: {
    if (!api.memory.has(memoryKeys.page)) {
      navigate(pages.library);
    } else {
      navigate(api.memory.get(memoryKeys.page));
    }
  }
}
