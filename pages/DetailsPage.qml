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

  Keys.onLeftPressed: {
    if (!event.isAutoRepeat) panelsList.previousItem()
  }

  Keys.onRightPressed: {
    if (!event.isAutoRepeat) panelsList.nextItem()
  }

  // quick actions panel
  Component {
    id: quickActionsPanel

    ColumnLayout {
      spacing: vpx(20)

      StyledText {
        Layout.fillWidth: true

        id: gameTitle
        text: currentGame.title
        font.pointSize: vpx(25)
        wrapMode: Text.Wrap
      }

      Rating {
        Layout.alignment: Qt.AlignRight
        id: rating
        rating: currentGame.rating
      }

      GameActions {
        Layout.fillWidth: true
        Layout.fillHeight: true
        game: currentGame
      }
    }
  }

  // images panel
  Component {
    id: imagesPanel

    ColumnLayout {
      spacing: vpx(20)

      StyledText {
        Layout.fillWidth: true
        id: imagesHeader
        text: 'Images'
        font.weight: Font.Black
      }

      GameImageViewer {
        game: currentGame
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
    }
  }

  // details panel
  Component {
    id: detailsPanel

    ColumnLayout {
      spacing: vpx(20)
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
        Layout.fillWidth: true
        text: 'Details'
        font.weight: Font.Black
      }

      GameDetails {
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        game: currentGame
      }
    }
  }

  // description panel
  Component {
    id: descriptionPanel

    ColumnLayout {
      spacing: vpx(20)

      StyledText {
        Layout.fillWidth: true

        id: aboutHeader
        text: 'Description'
        font.weight: Font.Black
      }

      Scrollable {
        Layout.fillWidth: true
        Layout.fillHeight: true

        contentHeight: descriptionText.contentHeight

        StyledText {
          id: descriptionText
          wrapMode: Text.WordWrap
          anchors.fill: parent
          text: currentGame.description || currentGame.summary
          textFormat: Text.StyledText
          color: '#80FFFFFF'
          layer.enabled: false
        }
      }
    }
  }

  PanelsList {
    id: panelsList
    panelWidth: vpx(458)
    panelHeight: vpx(494)
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
    anchors.right: parent.right
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
          asynchronous: true
          anchors.fill: parent
          anchors.leftMargin: vpx(30)
          anchors.topMargin: vpx(30)
          anchors.rightMargin: vpx(30)
          anchors.bottomMargin: vpx(30)
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
