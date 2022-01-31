import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtMultimedia 5.15

import "../components"

Item {
  property var imagePaths: api.memory.get(memoryKeys.imagePaths)
  property var isRunning: true
  property int currentIndex: 0

  focus: true
  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isCancel(event)) {
        navigate(pages.gameDetails);
        event.accepted = true;
        backSound.play();
      } else if (api.keys.isAccept(event)) {
        isRunning = !isRunning;
        selectSound.play();
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

    StyledText {
      id: pageText
      font.pointSize: vpx(16)
      font.weight: Font.Black
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      text: `${currentIndex + 1} | ${imagePaths.length}`
    }
  }

  Component.onCompleted: () => {
    setAvailableActions({
      [actionKeys.bottom]: {
        label: isRunning ? "Pause" : "Resume",
        visible: true,
      },
      [actionKeys.right]: {
        label: 'Back',
        visible: true
      }
    });
  }

  onIsRunningChanged: {
    setAvailableActions({
      [actionKeys.bottom]: {
        label: isRunning ? "Pause" : "Resume",
        visible: true,
      },
      [actionKeys.right]: {
        label: 'Back',
        visible: true
      }
    });
  }
}
