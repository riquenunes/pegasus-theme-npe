
import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "pages"

FocusScope {
  id: root

  function vpx(size) {
    return Math.round(size * (Screen.height / 720))
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
    'videoPath': 'video-path'
  }

  property var pages: {
    'library': 'LibraryPage.qml',
    'gameDetails': 'DetailsPage.qml',
    'videoPlayer': 'VideoPlayerPage.qml'
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
