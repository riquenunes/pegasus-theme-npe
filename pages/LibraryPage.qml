import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "../components"

Item {
  focus: true
  Image {
    source: "../assets/images/wallpapers/2.png"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Image {
    id: stage
    source: "../assets/images/stages/0003.png"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Component {
    id: sectionDelegate
    StyledText {
      id: sectionName
      anchors.left: parent.left
      horizontalAlignment: Text.AlignLeft
      opacity: PathView.itemOpacity
      z: index
      text: modelData.name
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

  Keys.onUpPressed: {
    if (!event.isAutoRepeat) {
      platformsList.incrementCurrentIndex()
      gamesList.generatePathPoints()
      channelUpSound.play()
    }
  }

  Keys.onDownPressed: {
    if (!event.isAutoRepeat) {
      platformsList.decrementCurrentIndex()
      gamesList.generatePathPoints()
      channelDownSound.play()
    }
  }

  Keys.onLeftPressed: {
    if (!event.isAutoRepeat) gamesList.decrementCurrentIndex()
  }

  Keys.onRightPressed: {
    if (!event.isAutoRepeat) gamesList.incrementCurrentIndex()
  }

  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isAccept(event)) {
        currentGame.launch();
        selectSound.play();
      } else if (api.keys.isDetails(event)) {
        navigate(pages.gameDetails, { [memoryKeys.currentGame]: currentGame });
        selectSound.play();
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

    path: Path {
      startX: 0; startY: platformsList.height - 21
      PathAttribute { name: "itemScale"; value: 1 }
      PathAttribute { name: "itemOpacity"; value: 1 }
      PathLine { x: 0; y: 0 }
      PathAttribute { name: "itemScale"; value: 0.39 }
      PathAttribute { name: "itemOpacity"; value: 0.2 }
    }
  }

  CardsList {
    id: gamesList
    cardWidth: getChannelsPanelDimensions(currentPlatform.games).width
    cardHeight: getChannelsPanelDimensions(currentPlatform.games).height
    model: currentPlatform.games
    anchors.top: platformsList.bottom
    anchors.left: platformsList.left
    anchors.right: parent.right
    anchors.leftMargin: vpx(3)
    anchors.topMargin: vpx(24)


    delegate: Item {
      property var style: getChannelsPanelStyle(currentPlatform.games);
      property string boxArt: modelData.assets.poster
      property bool hasBoxArt: !!boxArt

      Image {
        id: background
        height: parent.height
        width: parent.width
        source: modelData.assets.poster || modelData.assets.background || modelData.assets.screenshot || '../assets/images/panels/2.jpg'
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        mipmap: true
        layer.enabled: !modelData.assets.poster
          && (modelData.assets.background || modelData.assets.screenshot)
          && modelData.assets.logo
        layer.effect: FastBlur {
          anchors.fill: background
          source: background
          radius: 48
          cached: true
        }
      }

      Item {
        id: genericPanelOverlay
        width: parent.width
        height: parent.height
        visible: style === panelStyle.generic

        LinearGradient {
          anchors.fill: parent
          start: Qt.point(0, 0)
          end: Qt.point(0, parent.height)
          gradient: Gradient {
            GradientStop { position: .64; color: "#00000000" }
            GradientStop { position: 1; color: "#FF000000" }
          }
        }

        StyledText {
          font.pointSize: vpx(20)
          text: modelData.title
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: vpx(18)
          anchors.bottomMargin: vpx(43)
          anchors.rightMargin: vpx(18)
          elide: Text.ElideRight
        }

        StyledText {
          id: summary
          font.pointSize: vpx(16)
          text: modelData.summary
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: vpx(18)
          anchors.rightMargin: vpx(18)
          anchors.bottomMargin: vpx(15)
          opacity: .8
          elide: Text.ElideRight
          visible: !hasBoxArt && !summary.truncated
        }
      }

      Image {
        id: logo
        source: modelData.assets.logo
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        mipmap: true
        cache: true
        anchors.leftMargin: vpx(20)
        anchors.rightMargin: vpx(20)
        height: vpx(160)
        visible: modelData.assets.logo && !modelData.assets.poster

        // Cover panel specific options
        anchors.left: !genericPanelOverlay.visible ? parent.left : undefined
        anchors.right: !genericPanelOverlay.visible ? parent.right : undefined
        anchors.verticalCenter: !genericPanelOverlay.visible ? parent.verticalCenter : undefined

        // Generic panel specific options
        anchors.horizontalCenter: genericPanelOverlay.visible ? parent.horizontalCenter : undefined
        anchors.top: genericPanelOverlay.visible ? parent.top : undefined
        anchors.topMargin: genericPanelOverlay.visible ? vpx(52) : undefined
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
    color: "#616161"
    layer.effect: DropShadow {
      verticalOffset: vpx(1)
      horizontalOffset: vpx(1)
      color: "#55FFFFFF"
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
        label: 'Game details',
        visible: true
      }
    });
  }
}
