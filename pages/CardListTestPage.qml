import '../components'

import QtQuick 2.15
import QtGraphicalEffects 1.12


ListView {
  property real panelWidth: vpx(200)

  function getScale(screenIndex) {
    const scalesByScreenIndex = [
      1, .85938, .7531, .666, .600, .54688, .503, .4656, .42813, .403125, .375, .353125, .334375, .32, .32
    ];

    return scalesByScreenIndex[screenIndex];
  }

  function getXOffset(screenIndex) {
    if (screenIndex < 0) return 0;

    const distances = [0, -2, -27, -39, -48, -52, -54, -55, -54, -55, -52, -52, -50, -50,-50];
    const startingItemX = 0;

    if (screenIndex === 0) return startingItemX;

    const currentWidth = panelWidth * getScale(screenIndex);
    const previousWidth = panelWidth * getScale(screenIndex - 1);
    const previousX = getXOffset(screenIndex - 1);

    return previousWidth + previousX + vpx(distances[screenIndex]);
    return previousWidth + previousX - ((previousWidth - currentWidth) / 2) + vpx(distances[screenIndex]);
  }

  function getX(screenIndex) {
    if (screenIndex === 0) return 0;

    const initialWidth = panelWidth;
    const currentWidth = panelWidth * getScale(screenIndex);
    const widthDifference = currentWidth - initialWidth;
    const distances = [0, -2, -27, -39, -48, -52, -54, -55, -54, -55, -52, -52, -50, -50, -50];
    const previousDifference = getX(screenIndex - 1);

    return widthDifference / 2 + previousDifference + vpx(distances[screenIndex]);
  }

  id: list
  focus: true
  model: ListModel {
    Component.onCompleted: {
      for (let i = 0; i < 100; i++) {
        append({ element: i });
      }
    }
  }
  delegate: Rectangle {
    property int screenIndex: index - list.currentIndex

    color: 'Red'
    width: vpx(200)
    height: vpx(200)
    scale: getScale(screenIndex)
    z: -index

    Column {
      StyledText {
        text: `actual X: ${parent.parent.x}`
      }

      StyledText {
        text: `getX: ${getX(screenIndex)}`
      }
    }


    Behavior on scale {
      PropertyAnimation { duration: 1000 }
    }

    transform: Translate {
      x: getX(screenIndex)

      Behavior on x {
        PropertyAnimation { duration: 500 }
      }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 8
        verticalOffset: 8
    }
  }
  highlightMoveDuration: 1000
  orientation: Qt.Horizontal
  anchors.left: parent.left
  anchors.right: parent.right
  anchors.verticalCenter: parent.verticalCenter
  spacing: 0
  // snapMode: ListView.SnapToItem
  highlightRangeMode: ListView.StrictlyEnforceRange
  reuseItems: true
}


// currentIndex = 10
