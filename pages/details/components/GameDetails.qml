import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtQuick.Layouts 1.1

import "../../../components"

RowLayout {
  property var game

  spacing: vpx(25)

  Image {
    Layout.maximumWidth: vpx(156)
    Layout.alignment: Qt.AlignTop
    width: vpx(156)
    source: game.assets.poster || game.assets.boxFront || game.assets.logo
    asynchronous: true
    cache: true
    fillMode: Image.PreserveAspectFit
    verticalAlignment: Image.AlignTop
    sourceSize.height: height
    sourceSize.width: width
  }

  ColumnLayout {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop

    spacing: vpx(12)

    ColumnLayout {
      Layout.fillWidth: true

      StyledText {
        text: "Platform"
        font.weight: Font.Black
      }

      StyledText {
        Layout.fillWidth: true

        text: game.collections.get(0).name
        font.weight: Font.Black
        color: "#80FFFFFF"
        layer.enabled: false
        wrapMode: Text.Wrap
      }
    }

    ColumnLayout {
      Layout.fillWidth: true

      StyledText {
        text: "Developer"
        font.weight: Font.Black
      }

      StyledText {
        Layout.fillWidth: true

        text: game.developer
        font.weight: Font.Black
        color: "#80FFFFFF"
        layer.enabled: false
        wrapMode: Text.Wrap
      }
    }

    ColumnLayout {
      Layout.fillWidth: true

      StyledText {
        text: "Publisher"
        font.weight: Font.Black
        anchors.topMargin: vpx(25)
      }

      StyledText {
        Layout.fillWidth: true

        text: game.publisher
        font.weight: Font.Black
        color: "#80FFFFFF"
        layer.enabled: false
        wrapMode: Text.Wrap
      }
    }
  }
}
