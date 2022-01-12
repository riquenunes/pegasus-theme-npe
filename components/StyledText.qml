import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15

Text {
  color: "#FFF"
  font.pointSize: vpx(18)
  font.family: convectionui.name
  layer.enabled: true
  layer.effect: DropShadow {
    verticalOffset: 1
    horizontalOffset: 1
    color: "#80000000"
    radius: 2
    samples: 3
  }
}
