import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtMultimedia 5.15

Item {
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  property var videoPath: api.memory.get(memoryKeys.videoPath)
  focus: true
  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isCancel(event)) {
        navigate(pages.gameDetails);
        event.accepted = true;
      }
    }
  }

  Video {
    id: player
    width: parent.width
    height: parent.height
    source: videoPath
    anchors.fill: parent
    autoPlay: true
  }
}
