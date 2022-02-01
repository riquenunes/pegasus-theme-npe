import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import QtQuick.Layouts 1.1

import '../components'

Item {
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

  Keys.onLeftPressed: panelsList.decrementCurrentIndex()
  Keys.onRightPressed: panelsList.incrementCurrentIndex()

  // quick actions panel
  Component {
    id: quickActionsPanel

    Item {
      StyledText {
        id: gameTitle
        text: currentGame.title
        font.pointSize: vpx(25)
        anchors.right: parent.right
        anchors.left: parent.left
        wrapMode: Text.Wrap
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
            label: () => 'Play Now'
            action: () => currentGame.launch()
            canExecute: () => true
          }
          ListElement {
            label: () => 'Watch Preview'
            action: () => navigate(pages.videoPlayer, { [memoryKeys.videoPath]: currentGame.assets.video })
            canExecute: () => !!currentGame.assets.video
          }
          ListElement {
            label: () => !currentGame.favorite ? 'Pin to Home' : 'Remove Pin'
            action: () => currentGame.favorite = !currentGame.favorite
            canExecute: () => true
          }
        }
      }
    }
  }

  // images panel
  Component {
    id: imagesPanel

    Item {
      StyledText {
        id: imagesHeader
        text: 'Images'
        font.weight: Font.Black
      }

      ActionList {
        id: imageActions
        anchors.top: imagesHeader.bottom
        anchors.topMargin: vpx(25)
        focus: true
        model: ListModel {
          ListElement {
            label: () => 'View Full Screen'
            action: () => navigate(
              pages.imageViewer,
              {
                [memoryKeys.imagePaths]: [
                  ...currentGame.assets.screenshotList,
                  ...currentGame.assets.titlescreenList,
                  ...currentGame.assets.bannerList
                ]
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
          }

          StyledText {
            text: label()
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

  // details panel
  Component {
    id: detailsPanel

    Item {
      focus: true

      onActiveFocusChanged: {
        if (activeFocus) {
          setAvailableActions({
            [actionKeys.right]: {
              label: 'Back',
              visible: true
            }
          });
        }
      }

      StyledText {
        id: detailsHeader
        text: 'Details'
        font.weight: Font.Black
      }

      RowLayout {
        spacing: vpx(25)
        anchors.topMargin: vpx(25)
        anchors.top: detailsHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Image {
          Layout.maximumWidth: vpx(156)
          Layout.alignment: Qt.AlignTop
          width: vpx(156)
          source: currentGame.assets.poster || currentGame.assets.boxFront || currentGame.assets.logo
          asynchronous: true
          cache: true
          fillMode: Image.PreserveAspectFit
          verticalAlignment: Image.AlignTop
        }

        ColumnLayout {
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignTop

          spacing: vpx(12)

          ColumnLayout {
            Layout.fillWidth: true

            StyledText {
              text: 'Platform'
              font.weight: Font.Black
            }

            StyledText {
              Layout.fillWidth: true

              text: currentGame.collections.get(0).name
              font.weight: Font.Black
              color: '#80FFFFFF'
              layer.enabled: false
              wrapMode: Text.Wrap
            }
          }

          ColumnLayout {
            Layout.fillWidth: true

            StyledText {
              text: 'Developer'
              font.weight: Font.Black
            }

            StyledText {
              Layout.fillWidth: true

              text: currentGame.developer
              font.weight: Font.Black
              color: '#80FFFFFF'
              layer.enabled: false
              wrapMode: Text.Wrap
            }
          }

          ColumnLayout {
            Layout.fillWidth: true

            StyledText {
              text: 'Publisher'
              font.weight: Font.Black
              anchors.topMargin: vpx(25)
            }

            StyledText {
              Layout.fillWidth: true

              text: currentGame.publisher
              font.weight: Font.Black
              color: '#80FFFFFF'
              layer.enabled: false
              wrapMode: Text.Wrap
            }
          }
        }
      }
    }
  }

  // description panel
  Component {
    id: descriptionPanel

    Item {
      StyledText {
        id: aboutHeader
        text: 'Description'
        font.weight: Font.Black
      }

      Flickable {
        id: descriptionFlickable
        focus: true
        anchors.topMargin: vpx(25)
        anchors.bottomMargin: vpx(25)
        anchors.top: aboutHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        contentHeight: descriptionText.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        Keys.onUpPressed:   flick(0,  800)
        Keys.onDownPressed: flick(0, -800)

        StyledText {
          id: descriptionText
          anchors.left: parent.left
          anchors.right: parent.right
          wrapMode: Text.WordWrap
          text: currentGame.description || currentGame.summary
          textFormat: Text.StyledText
          color: '#80FFFFFF'
          layer.enabled: false
        }

        onActiveFocusChanged: {
          if (activeFocus) {
            setAvailableActions({
              [actionKeys.right]: {
                label: 'Back',
                visible: true
              }
            });
          }
        }
      }

      Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Image {
          source: descriptionFlickable.verticalVelocity < 0
            ? '../assets/images/icons/up-focus.png'
            : '../assets/images/icons/up-default.png'
          opacity: descriptionFlickable.atYBeginning ? 0 : 1
        }

        Image {
          source: descriptionFlickable.verticalVelocity > 0
            ? '../assets/images/icons/down-focus.png'
            : '../assets/images/icons/down-default.png'
          opacity: descriptionFlickable.atYEnd ? 0 : 1
        }
      }
    }
  }

  PanelsList {
    id: panelsList
    panelWidth: vpx(450)
    panelHeight: vpx(480)
    model: ListModel {
      ListElement {
        type: 'quick-actions'
        component: () => quickActionsPanel
      }
      ListElement {
        type: 'images'
        component: () => imagesPanel
      }
      ListElement {
        type: 'details'
        component: () => detailsPanel
      }
      ListElement {
        type: 'description'
        component: () => descriptionPanel
      }
    }
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: vpx(67)
    indexPersistenceKey: memoryKeys.gameDetailsPanelIndex
    delegate: PanelWrapper {
      Rectangle {
        width: parent.width
        height: parent.height

        LinearGradient {
          anchors.fill: parent
          start: Qt.point(0, 0)
          end: Qt.point(parent.width, parent.height)
          gradient: Gradient {
            GradientStop { position: 0; color: '#50616e' }
            GradientStop { position: .6; color: '#283743' }
            GradientStop { position: 1; color: '#29333d' }
          }
        }

        Loader {
          id: loader
          anchors.fill: parent
          anchors.leftMargin: vpx(25)
          anchors.topMargin: vpx(25)
          anchors.rightMargin: vpx(25)
          anchors.bottomMargin: vpx(25)
          sourceComponent: component()
        }

        Component.onCompleted: () => {
          setAvailableActions({
            [actionKeys.right]: {
              label: 'Back',
              visible: true
            }
          });

          loader.forceActiveFocus();
        }
      }
    }
  }

  Keys.onPressed: {
    if (!event.isAutoRepeat && api.keys.isCancel(event)) {
      api.memory.set(memoryKeys.gameDetailsPanelIndex, 0);
      navigate(pages.library);
    }
  }
}
