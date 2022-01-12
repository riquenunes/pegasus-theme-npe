import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtMultimedia 5.15

import "../components"

Item {
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  property var imagePaths: api.memory.get(memoryKeys.imagePaths)
  property var isRunning: true
  property int currentIndex: 0

  focus: true
  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isCancel(event)) {
        navigate(pages.gameDetails);
        event.accepted = true;
      } else if (api.keys.isAccept(event)) {
        isRunning = !isRunning;
      }
    }
  }

  function nextImage() {
    currentIndex = (currentIndex + 1) % imagePaths.length;
    timer.restart();
  }

  function previousImage() {
    currentIndex = (currentIndex == 0 ? imagePaths.length : currentIndex) - 1;
    timer.restart();
  }

  Keys.onLeftPressed: previousImage()
  Keys.onRightPressed: nextImage()

  Timer {
    id: timer
    interval: 5000; running: isRunning; repeat: true
    onTriggered: nextImage()
  }

  Image {
    id: player
    anchors.fill: parent
    source: imagePaths[currentIndex]
    fillMode: Image.PreserveAspectFit
  }

  Item {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: vpx(48)
    scale: 0

    SequentialAnimation on scale  {
      NumberAnimation {
        from: 0
        to: 1
        duration: 500
        easing.type: Easing.OutBounce
      }
    }

    Rectangle {
      color: "#000"
      opacity: .8
      width: pageText.width + vpx(128)
      height: pageText.height + vpx(32)
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      radius: height
    }

    Text {
      id: pageText
      color: "#FFF"
      font.pointSize: vpx(16)
      font.family: convectionui.name
      font.weight: Font.Black
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      text: `${currentIndex + 1} | ${imagePaths.length}`
    }
  }

  ButtonPrompt {
    id: selectPrompt
    button: "a"
    text: isRunning ? "Pause" : "Resume"
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: vpx(95)
    anchors.bottomMargin: vpx(55)
  }

  ButtonPrompt {
    button: "b"
    text: "Back"
    anchors.left: selectPrompt.right
    anchors.leftMargin: vpx(21)
    anchors.verticalCenter: selectPrompt.verticalCenter
  }
}
