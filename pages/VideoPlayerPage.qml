import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtMultimedia 5.15

Item {
  property var videoPath: api.memory.get(memoryKeys.videoPath)
  focus: true
  Keys.onPressed: {
    if (!event.isAutoRepeat && api.keys.isCancel(event)) {
      navigate(pages.gameDetails);
    }
  }

  Rectangle {
    color: 'black'
    anchors.fill: parent
  }

  Video {
    id: player
    source: videoPath
    anchors.fill: parent
    autoPlay: true
  }

  Component.onCompleted: () => {
    setAvailableActions({
      [actionKeys.right]: {
        label: 'Back',
        visible: true
      }
    });
  }
}
