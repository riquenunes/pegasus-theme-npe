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
      label: () => 'View Full Screen'
      action: () => navigate(
        pages.imageViewer,
        {
          [memoryKeys.imagePaths]: [
            ...game.assets.screenshotList,
            ...game.assets.titlescreenList,
            ...game.assets.bannerList
          ]
        }
      )
      canExecute: () => true
    }
  }
  delegate: Column {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    spacing: vpx(16)

    Item {
      height: 1
      anchors.left: parent.left
      anchors.right: parent.right
    }

    ImageViewer {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: vpx(16)
      anchors.rightMargin: vpx(16)
      height: vpx(206)
      running: true
      imagePaths: [
        ...game.assets.screenshotList,
        ...game.assets.titlescreenList,
        ...game.assets.bannerList
      ]
    }

    // Image {
    //   anchors.left: parent.left
    //   anchors.right: parent.right
    //   fillMode: Image.PreserveAspectFit

    //   anchors.leftMargin: vpx(16)
    //   anchors.rightMargin: vpx(16)
    //   source: game.assets.screenshot
    //     || game.assets.titlescreen
    //     || game.assets.banner
    // }

    StyledText {
      text: label()
      font.weight: Font.Black
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: vpx(16)
      anchors.rightMargin: vpx(16)
      anchors.bottomMargin: vpx(16)
    }

    Item {
      height: 1
      anchors.left: parent.left
      anchors.right: parent.right
    }

    Keys.onPressed: {
      if (api.keys.isAccept(event) && canExecute() && !event.isAutoRepeat) {
        action();
      }
    }
  }
}
