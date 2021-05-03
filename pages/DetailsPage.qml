import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "../components"

Item {
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  property var currentGame: api.memory.get(memoryKeys.game)

  Image {
    source: currentGame.assets.background
      || currentGame.assets.banner
      || currentGame.assets.screenshot
      || currentGame.assets.titlescreen
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  CardsList {
    id: gamesList
    cardWidth: vpx(450)
    cardHeight: vpx(480)
    model: ListModel {
        ListElement {
          name: "Bill Jones"
          icon: "pics/qtlogo.png"
          type: "quick-actions"
        }
        ListElement {
          name: "Jane Doe"
          icon: "pics/qtlogo.png"
        }
        ListElement {
          name: "John Smith"
          icon: "pics/qtlogo.png"
          type: "description"
        }
    }
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: vpx(67)
    delegate: Item {
      Rectangle {
        width: parent.width
        height: parent.height
        gradient: Gradient {
          GradientStop { position: 0.0; color: "#465052" }
          GradientStop { position: 1.0; color: "#1a1e1d" }
        }

        Item {
          visible: modelData.type === "quick-actions"
          anchors.fill: parent
          anchors.leftMargin: vpx(25)
          anchors.topMargin: vpx(25)
          anchors.rightMargin: vpx(25)
          anchors.bottomMargin: vpx(25)

          Text {
            id: gameTitle
            text: currentGame.title
            color: "#FFF"
            font.pointSize: vpx(25)
            font.family: convectionui.name
          }
        }

        Item {
          visible: modelData.type === "description"
          anchors.fill: parent
          anchors.leftMargin: vpx(54)
          anchors.topMargin: vpx(25)
          anchors.rightMargin: vpx(25)
          anchors.bottomMargin: vpx(25)
          Text {
            id: detailsHeader
            text: "About This Game"
            color: "#FFF"
            font.pointSize: vpx(18)
            font.family: convectionui.name
            font.weight: Font.Black
          }

          Text {
            color: "#FFF"
            font.pointSize: vpx(18)
            font.family: convectionui.name
            font.weight: Font.ExtraLight
            anchors.top: detailsHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            wrapMode: Text.WordWrap
            text: currentGame.description
            textFormat: Text.StyledText
          }
        }
      }
    }
  }

  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isCancel(event)) {
        api.memory.set(memoryKeys.page, pages.library);
        event.accepted = true;
      }
    }
  }

  ButtonPrompt {
    id: selectPrompt
    button: "a"
    text: "Select"
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: vpx(95)
    anchors.bottomMargin: vpx(55)
  }

  ButtonPrompt {
    button: "b"
    text: "Back"
    anchors.left: selectPrompt.right
    anchors.leftMargin: vpx(21)
    anchors.verticalCenter: selectPrompt.verticalCenter
  }
}
