import QtQuick 2.8
import QtGraphicalEffects 1.0

Item {
  property string button
  property string text
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  width: icon.width + label.contentWidth + label.anchors.leftMargin
  height: icon.height

  Image {
    id: icon
    source: `../assets/images/buttons/${button}.png`
    width: vpx(32)
    height: vpx(32)
  }

  Text {
    id: label
    anchors.left: icon.right
    anchors.verticalCenter: icon.verticalCenter
    anchors.leftMargin: vpx(4)
    color: '#FFF'
    text: parent.text
    font.family: convectionui.name
    font.pointSize: vpx(14)
    font.letterSpacing: vpx(1)
    layer.enabled: true
    layer.effect: DropShadow {
      verticalOffset: vpx(1)
      horizontalOffset: vpx(1)
      color: "#88000000"
      radius: 1
      samples: vpx(1)
    }
    transform: Translate {
      y: vpx(1)
    }
  }
}
