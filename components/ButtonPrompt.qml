import QtQuick 2.8
import QtGraphicalEffects 1.0

Item {
  property string button
  property string text
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  width: icon.width + label.contentWidth + label.anchors.leftMargin

  Image {
    id: icon
    source: `../assets/images/buttons/${button}.png`
    width: vpx(48)
    height: vpx(48)
  }

  Text {
    id: label
    anchors.left: icon.right
    anchors.verticalCenter: icon.verticalCenter
    anchors.leftMargin: vpx(7)
    color: '#FFF'
    text: parent.text
    font.family: convectionui.name
    font.pointSize: 19
    layer.enabled: true
    layer.effect: DropShadow {
      verticalOffset: 1
      horizontalOffset: 1
      color: "#000"
      radius: 2
      samples: 2
    }
  }
}
