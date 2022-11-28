import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtQuick.Layouts 1.1
import "../js/enums.mjs" as Enums

Item {
  default property alias content: flickable.children
  property alias contentHeight: flickable.contentHeight

  onContentChanged: {
    if (flickable.children[1]) {
      flickable.children[1].parent = flickable.contentItem
    }
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: vpx(10)

    Flickable {
      Layout.fillHeight: true
      Layout.fillWidth: true

      id: flickable
      focus: true
      clip: true
      interactive: true
      boundsBehavior: Flickable.StopAtBounds
      Keys.onUpPressed: flick(0, vpx(800))
      Keys.onDownPressed: flick(0, -vpx(800))

      onActiveFocusChanged: {
        if (activeFocus) {
          setAvailableActions({
            [Enums.ActionKeys.Right]: {
              label: "Back",
              visible: true
            }
          });
        }
      }
    }

    Row {
      Layout.alignment: Qt.AlignRight

      Image {
        source: flickable.verticalVelocity < 0
          ? "../assets/images/icons/up-focus.png"
          : "../assets/images/icons/up-default.png"
        opacity: flickable.atYBeginning ? 0 : 1
        width: vpx(26)
        height: vpx(22)
      }

      Image {
        source: flickable.verticalVelocity > 0
          ? "../assets/images/icons/down-focus.png"
          : "../assets/images/icons/down-default.png"
        opacity: flickable.atYEnd ? 0 : 1
        width: vpx(26)
        height: vpx(22)
      }
    }
  }
}
