import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtMultimedia 5.15

import '../components'

Item {
  property var imagePaths: api.memory.get(memoryKeys.imagePaths)
  property alias running: viewer.running

  focus: true
  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isCancel(event)) {
        navigate(pages.gameDetails);
      } else if (api.keys.isAccept(event)) {
        running = !running;
      }
    }
  }


  Keys.onLeftPressed: viewer.previousImage()
  Keys.onRightPressed: viewer.nextImage()

  ImageViewer {
    id: viewer
    anchors.fill: parent
    imagePaths: parent.imagePaths
    running: true
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
      color: '#000'
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
      text: `${viewer.currentIndex + 1} | ${imagePaths.length}`
    }
  }

  Component.onCompleted: () => {
    setAvailableActions({
      [actionKeys.bottom]: {
        label: running ? 'Pause' : 'Resume',
        visible: true,
      },
      [actionKeys.right]: {
        label: 'Back',
        visible: true
      }
    });
  }

  onRunningChanged: {
    setAvailableActions({
      [actionKeys.bottom]: {
        label: running ? 'Pause' : 'Resume',
        visible: true,
      },
      [actionKeys.right]: {
        label: 'Back',
        visible: true
      }
    });
  }
}
