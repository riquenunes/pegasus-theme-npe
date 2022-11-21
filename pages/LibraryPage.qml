import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import '../components'

Item {
  focus: true

  Component {
    id: sectionDelegate
    StyledText {
      id: sectionName
      anchors.left: parent.left
      horizontalAlignment: Text.AlignLeft
      opacity: PathView.itemOpacity
      z: index
      text: name
      font.pointSize: vpx(30)
      transform:[
        Translate {
          y: -sectionName.height * (1 - sectionName.PathView.itemOpacity)
        },
        Scale {
          xScale: sectionName.PathView.itemScale
          yScale: sectionName.PathView.itemScale
        }
      ]
    }
  }

  property var currentPlatform: api.collections.get(platformsList.currentIndex)
  property var currentGame: currentPlatform.games.get(gamesList.currentIndex)
  property var style: getChannelsPanelStyle(currentPlatform.games)
  property var panelDimensions: getChannelsPanelDimensions(currentPlatform.games, style)

  Keys.onUpPressed: {
    if (!event.isAutoRepeat) {
      platformsList.incrementCurrentIndex()
    }
  }

  Keys.onDownPressed: {
    if (!event.isAutoRepeat) {
      platformsList.decrementCurrentIndex()
    }
  }

  Keys.onLeftPressed: {
    if (!event.isAutoRepeat) gamesList.previousItem()
  }

  Keys.onRightPressed: {
    if (!event.isAutoRepeat) gamesList.nextItem()
  }

  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isAccept(event)) {
        currentGame.launch();
      } else if (api.keys.isDetails(event)) {
        stage.state = 'Invisible';
        navigate(pages.gameDetails, { [memoryKeys.currentGame]: currentGame });
      }
    }
  }

  PathView {
    id: platformsList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.leftMargin: vpx(92)
    anchors.topMargin: vpx(74)
    height: vpx(149)
    model: api.collections
    delegate: sectionDelegate
    pathItemCount: 5
    property int previousIndex: 0

    path: Path {
      startX: 0; startY: platformsList.height - 21
      PathAttribute { name: 'itemScale'; value: 1 }
      PathAttribute { name: 'itemOpacity'; value: 1 }
      PathLine { x: 0; y: 0 }
      PathAttribute { name: 'itemScale'; value: 0.39 }
      PathAttribute { name: 'itemOpacity'; value: 0.2 }
    }

    onCurrentItemChanged: {
      if (currentIndex !== previousIndex) {
        if (currentIndex > previousIndex) channelUpSound.play();
        if (currentIndex < previousIndex) channelDownSound.play();

        api.memory.set(memoryKeys.libraryChannelIndex, currentIndex);
      }

      previousIndex = currentIndex;
    }

    Component.onCompleted: {
      platformsList.currentIndex = api.memory.get(memoryKeys.libraryChannelIndex) || 0;
    }
  }

  PanelsList {
    id: gamesList
    panelWidth: panelDimensions.width
    panelHeight: panelDimensions.height
    model: currentPlatform.games
    anchors.top: platformsList.bottom
    anchors.left: platformsList.left
    anchors.right: parent.right
    anchors.leftMargin: vpx(3)
    anchors.topMargin: vpx(24)
    indexPersistenceKey: memoryKeys.libraryPanelIndex

    delegate: PanelWrapper {
      property var posterBackground: style === panelStyle.cover ? assets.poster : undefined
      property var backgroundSource: posterBackground || assets.steam || assets.background || assets.banner

      Image {
        id: background
        height: parent.height
        width: parent.width
        sourceSize.width: width
        sourceSize.height: height
        source: backgroundSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
      }

      Image {
        id: fallbackBackground
        fillMode: Image.PreserveAspectCrop
        anchors.fill: background
        source: `../assets/images/contenttabs/green/backgrounds/${index % 8 + 1}.png`
        visible: background.status != Image.Ready
      }
      
      Image {
        id: genericIcon
        fillMode: Image.PreserveAspectFit
        source: `../assets/images/contenttabs/green/icons/controller.png`
        visible: fallbackBackground.visible

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height: vpx(200)
        sourceSize.height: height

      }

      Item {
        id: genericPanelOverlay
        width: parent.width
        height: parent.height
        visible: genericIcon.visible || style === panelStyle.generic

        LinearGradient {
          anchors.fill: parent
          start: Qt.point(0, 0)
          end: Qt.point(0, parent.height)
          gradient: Gradient {
            GradientStop { position: .64; color: '#00000000' }
            GradientStop { position: 1; color: '#FF000000' }
          }
        }

        StyledText {
          font.pointSize: vpx(20)
          text: title
          anchors.bottom: summaryText.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: vpx(18)
          anchors.rightMargin: vpx(18)
          anchors.bottomMargin: vpx(4)
          elide: Text.ElideRight
        }

        StyledText {
          id: summaryText
          font.pointSize: vpx(16)
          text: summary
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: vpx(18)
          anchors.rightMargin: vpx(18)
          anchors.bottomMargin: vpx(15)
          anchors.topMargin: vpx(20)
          opacity: .8
          elide: Text.ElideRight
          visible: !truncated
          maximumLineCount: 1
        }
      }
    }
  }

  StyledText {
    text: `${gamesList.currentIndex + 1} of ${currentPlatform.games.count}  |  ${currentGame.title}`
    anchors.top: gamesList.bottom
    anchors.topMargin: vpx(9)
    anchors.left: parent.left
    anchors.leftMargin: vpx(96)
    font.pointSize: vpx(15)
    color: '#616161'
    layer.effect: DropShadow {
      verticalOffset: vpx(1)
      horizontalOffset: vpx(1)
      color: '#55FFFFFF'
      radius: vpx(2)
      samples: vpx(1)
    }
  }

  Component.onCompleted: {
    setAvailableActions({
      [actionKeys.bottom]: {
        label: 'Select',
        visible: true
      },
      [actionKeys.left]: {
        label: 'Game Details',
        visible: true
      }
    });
  }
}
