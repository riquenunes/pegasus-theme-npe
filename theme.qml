
import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "pages"

FocusScope {
  id: root

  function vpx(size) {
    return Math.round(size * (Screen.height / 720))
  }

  property var memoryKeys: {
    'page': 'page',
    'game': 'game'
  }

  property var pages: {
    'library': 'library',
    'gameDetails': 'game-details'
  }

  LibraryPage {
    visible: api.memory.get(memoryKeys.page) === pages.library
    focus: visible
    anchors.fill: parent
  }

  DetailsPage {
    visible: api.memory.get(memoryKeys.page) === pages.gameDetails
    focus: visible
    anchors.fill: parent
  }

  Component.onCompleted: {
    if (!memory.has(memoryKeys.page)) api.memory.set(memoryKeys.page, pages.library)
  }
}
