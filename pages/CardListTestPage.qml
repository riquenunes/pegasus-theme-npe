import "../components"

import QtQuick 2.15
import QtGraphicalEffects 1.12


ListView {
  id: list
  focus: true
  model: ListModel {
    Component.onCompleted: {
      for (let i = 0; i < 300; i++) {
        append({ element: i });
      }
    }
  }
  cacheBuffer: 14
  delegate: Rectangle {
    property int screenIndex: index - list.currentIndex

    color: "Red"
    width: vpx(420)
    height: vpx(320)
    scale: ListView.isCurrentItem ? 1 : 0.78
    // opacity: screenIndex < 0 ? 0 : 1
    z: -index + (ListView.isCurrentItem ? 100 : 0)

    Column {
      StyledText {
        text: `actual X: ${parent.parent.x}`
      }

      StyledText {
        text: `getX: ${getX(screenIndex)}`
      }

      StyledText {
        text: `screenIndex: ${screenIndex}`
      }
    }


    Behavior on opacity {
      PropertyAnimation { duration: 300 }
    }

    Behavior on scale {
      PropertyAnimation { duration: 300 }
    }


    // transform: Translate {
    //   x: getX(screenIndex)

    //   Behavior on x {
    //     PropertyAnimation { duration: 300 }
    //   }
    // }



    // layer.enabled: true
    // layer.effect: DropShadow {
    //     transparentBorder: true
    //     horizontalOffset: 8
    //     verticalOffset: 8
    // }
  }
  // add: Transition {
  //   ParallelAnimation {
  //     NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 300 }
  //     // NumberAnimation { properties: "x"; from: x-width; to: x; duration: 3000 }
  //   }
  // }
  // displaced: Transition {
  //   NumberAnimation { properties: "opacity"; from: 1; to: 0; duration: 3000 }
  // }
  orientation: Qt.Horizontal
  anchors.fill: parent
  spacing: vpx(-82)
  snapMode: ListView.SnapToItem
  highlightRangeMode: ListView.StrictlyEnforceRange
  // highlightFollowsCurrentItem : true
  highlightResizeDuration: 300
  highlightMoveDuration: 300
  highlightMoveVelocity: -1
  highlightResizeVelocity: -1
  preferredHighlightBegin: vpx(300)
  preferredHighlightEnd: vpx(300) + vpx(420)
  reuseItems: false
}


// currentIndex = 10
