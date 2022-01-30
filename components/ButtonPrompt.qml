import QtQuick 2.8
import QtGraphicalEffects 1.0

Item {
  property string button
  property string text
  width: icon.width + label.contentWidth + label.anchors.leftMargin
  height: icon.height

  Image {
    id: icon
    source: `../assets/images/buttons/${button}.png`
    width: vpx(32)
    height: vpx(32)
  }

  StyledText {
    id: label
    anchors.left: icon.right
    anchors.verticalCenter: icon.verticalCenter
    anchors.leftMargin: vpx(4)
    text: parent.text
    font.pointSize: vpx(14)
    transform: Translate {
      y: vpx(1)
    }
  }
}
