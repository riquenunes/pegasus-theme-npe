import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtQuick.Layouts 1.1

ActionList {
  property var game

  focus: true
  model: ListModel {
    ListElement {
      label: () => 'Play Now'
      action: () => game.launch()
      canExecute: () => true
    }
    ListElement {
      label: () => 'Watch Preview'
      action: () => navigate(pages.videoPlayer, { [memoryKeys.videoPath]: game.assets.video })
      canExecute: () => !!game.assets.video
    }
    ListElement {
      label: () => !game.favorite ? 'Pin to Home' : 'Remove Pin'
      action: () => game.favorite = !game.favorite
      canExecute: () => true
    }
  }
}
