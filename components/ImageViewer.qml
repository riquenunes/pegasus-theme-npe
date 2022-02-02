import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtMultimedia 5.15

Item {
  property alias running: timer.running
  property int currentIndex: 0
  property var imagePaths: []

  function nextImage() {
    currentIndex = (currentIndex + 1) % imagePaths.length;
    timer.restart();
  }

  function previousImage() {
    currentIndex = (currentIndex == 0 ? imagePaths.length : currentIndex) - 1;
    timer.restart();
  }

  Timer {
    id: timer
    interval: 5000; repeat: true
    onTriggered: nextImage()
  }

  Rectangle {
    color: 'black'
    anchors.fill: parent
    Image {
      id: player
      anchors.fill: parent
      source: imagePaths[currentIndex]
      fillMode: Image.PreserveAspectFit
    }
  }
}
