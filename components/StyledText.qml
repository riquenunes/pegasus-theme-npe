import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15

Text {
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  color: "#FFF"
  font.pixelSize: vpx(24)
  font.family: convectionui.name
  font.letterSpacing: vpx(.4, false)
  layer.enabled: true
  layer.effect: DropShadow {
    verticalOffset: vpx(1, false)
    horizontalOffset: vpx(1, false)
    color: "#80000000"
    radius: vpx(2, false)
    samples: 1
  }
}
