import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15

import "../components"

Item {
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  property var currentGame: api.memory.get(memoryKeys.currentGame)
  property var screenshotPath: currentGame.assets.background
      || currentGame.assets.banner
      || currentGame.assets.screenshot
      || currentGame.assets.titlescreen

  focus: true

  Image {
    source: screenshotPath
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Keys.onLeftPressed: cardsList.decrementCurrentIndex()
  Keys.onRightPressed: cardsList.incrementCurrentIndex()

  // quick actions card
  Component {
    id: quickActionsCard

    Item {
      Text {
        id: gameTitle
        text: currentGame.title
        color: "#FFF"
        font.pointSize: vpx(25)
        font.family: convectionui.name
      }

      Rating {
        id: rating
        rating: currentGame.rating
        anchors.topMargin: vpx(35)
        anchors.top: gameTitle.bottom
        anchors.right: parent.right
      }

      ActionList {
        id: quickActions
        focus: true
        model: ListModel {
          ListElement {
            label: () => "Play Now"
            action: () => currentGame.launch()
            canExecute: () => true
          }
          ListElement {
            label: () => "Watch Preview"
            action: () => navigate(pages.videoPlayer, { [memoryKeys.videoPath]: currentGame.assets.video })
            canExecute: () => !!currentGame.assets.video
          }
          ListElement {
            label: () => !currentGame.favorite ? "Pin to Home" : "Remove Pin"
            action: () => currentGame.favorite = !currentGame.favorite
            canExecute: () => true
          }
        }
      }
    }
  }

  // images card
  Component {
    id: imagesCard

    Item {
      Text {
        id: imagesHeader
        text: "Images"
        color: "#FFF"
        font.pointSize: vpx(18)
        font.family: convectionui.name
        font.weight: Font.Black
      }

      ActionList {
        id: imageActions
        anchors.top: imagesHeader.bottom
        anchors.topMargin: vpx(25)
        focus: true
        model: ListModel {
          ListElement {
            label: () => "View Full Screen"
            action: () => navigate(
              pages.imageViewer,
              {
                [memoryKeys.imagePaths]: [
                  currentGame.assets.screenshot,
                  currentGame.assets.titlescreen,
                  currentGame.assets.banner,
                  currentGame.assets.background
                ].filter(i => i)
              }
            )
            canExecute: () => true
          }
        }
        delegate: Column {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          spacing: vpx(16)

          Item {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
          }

          Image {
            anchors.left: parent.left
            anchors.right: parent.right
            fillMode: Image.PreserveAspectFit

            anchors.leftMargin: vpx(16)
            anchors.rightMargin: vpx(16)
            source: currentGame.assets.screenshot
              || currentGame.assets.titlescreen
              || currentGame.assets.banner
              || currentGame.assets.background
          }

          Text {
            text: label()
            color: "#FFF"
            font.pointSize: vpx(14)
            font.family: convectionui.name
            font.weight: Font.Black
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: vpx(16)
            anchors.rightMargin: vpx(16)
            anchors.bottomMargin: vpx(16)
          }

          Item {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
          }

          Keys.onPressed: {
            if (api.keys.isAccept(event) && canExecute() && !event.isAutoRepeat) {
              action();
            }
          }
        }
      }
    }
  }

  // details card
  Component {
    id: detailsCard

    Item {
      Text {
        id: detailsHeader
        text: "Details"
        color: "#FFF"
        font.pointSize: vpx(18)
        font.family: convectionui.name
        font.weight: Font.Black
      }

      Row {
        spacing: vpx(25)
        anchors.topMargin: vpx(25)
        anchors.top: detailsHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Image {
          width: vpx(156)
          source: currentGame.assets.poster || currentGame.assets.boxFront || currentGame.assets.logo
          asynchronous: true
          mipmap: true
          fillMode: Image.PreserveAspectFit

        }

        Column {
          spacing: vpx(12)

          Column {
            Text {
              text: "Platform"
              color: "#FFF"
              font.pointSize: vpx(18)
              font.family: convectionui.name
              font.weight: Font.Black
            }

            Text {
              text: currentGame.collections.get(0).name
              color: "#FFF"
              font.pointSize: vpx(18)
              font.family: convectionui.name
              font.weight: Font.Black
              opacity: 0.5
            }
          }

          Column {
            Text {
              text: "Developer"
              color: "#FFF"
              font.pointSize: vpx(18)
              font.family: convectionui.name
              font.weight: Font.Black
            }

            Text {
              text: currentGame.developer
              color: "#FFF"
              font.pointSize: vpx(18)
              font.family: convectionui.name
              font.weight: Font.Black
              opacity: 0.5
            }
          }

          Column {
            Text {
              text: "Publisher"
              color: "#FFF"
              font.pointSize: vpx(18)
              font.family: convectionui.name
              font.weight: Font.Black
              anchors.topMargin: vpx(25)
            }

            Text {
              text: currentGame.publisher
              color: "#FFF"
              font.pointSize: vpx(18)
              font.family: convectionui.name
              font.weight: Font.Black
              opacity: 0.5
            }
          }
        }
      }
    }
  }

  // description card
  Component {
    id: descriptionCard

    Item {
      Text {
        id: aboutHeader
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
        anchors.topMargin: vpx(25)
        anchors.top: aboutHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        text: currentGame.description || currentGame.summary
        textFormat: Text.StyledText
        opacity: 0.5
      }
    }
  }

  CardsList {
    id: cardsList
    cardWidth: vpx(450)
    cardHeight: vpx(480)
    model: ListModel {
      ListElement {
        type: "quick-actions"
        component: () => quickActionsCard
      }
      ListElement {
        type: "images"
        component: () => imagesCard
      }
      ListElement {
        type: "details"
        component: () => detailsCard
      }
      ListElement {
        type: "description"
        component: () => descriptionCard
      }
    }
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: vpx(67)
    delegate: Rectangle {
      width: parent.width
      height: parent.height

      gradient: Gradient {
        GradientStop { position: 0.0; color: "#465052" }
        GradientStop { position: 1.0; color: "#1a1e1d" }
      }

      Loader {
        id: loader
        focus: isCurrentItem
        anchors.fill: parent
        anchors.leftMargin: vpx(25)
        anchors.topMargin: vpx(25)
        anchors.rightMargin: vpx(25)
        anchors.bottomMargin: vpx(25)
        sourceComponent: modelData.component()
      }

      Connections {
        target: cardsList
        function onCurrentIndexChanged() {
          isCurrentItem && loader.forceActiveFocus();
        }
      }
    }
  }

  Keys.onPressed: {
    if (!event.isAutoRepeat && api.keys.isCancel(event)) {
      navigate(pages.library);
      event.accepted = true;
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
