import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "../components"

Item {
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }

  Image {
    source: "../assets/images/wallpapers/0002.jpg"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Image {
    source: "../assets/images/stages/0003.png"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Component {
    id: sectionDelegate
    Text {
      id: sectionName
      anchors.left: parent.left
      horizontalAlignment: Text.AlignLeft
      opacity: PathView.itemOpacity
      z: index
      text: modelData.name
      color: '#FFF'
      font.pointSize: vpx(30)
      font.family: convectionui.name
      transform:[
        Translate {
          y: -sectionName.height * (1 - sectionName.PathView.itemOpacity)

        },
        Scale {
          xScale: sectionName.PathView.itemScale
          yScale: sectionName.PathView.itemScale
        }
      ]
      layer.enabled: true
      layer.effect: DropShadow {
        verticalOffset: vpx(1)
        horizontalOffset: vpx(1)
        color: "#88000000"
        radius: 1
        samples: vpx(1)
      }
    }
  }

  property var currentPlatform: api.collections.get(platformsList.currentIndex)
  property var currentGame: currentPlatform.games.get(gamesList.currentIndex)

  Keys.onUpPressed: {
    platformsList.incrementCurrentIndex()
    gamesList.generatePathPoints()
  }

  Keys.onDownPressed: {
    platformsList.decrementCurrentIndex()
    gamesList.generatePathPoints()
  }

  Keys.onLeftPressed: gamesList.decrementCurrentIndex()
  Keys.onRightPressed: gamesList.incrementCurrentIndex()
  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isAccept(event)) {
        currentGame.launch();
      } else if (api.keys.isDetails(event)) {
        api.memory.set(memoryKeys.game, currentGame);
        api.memory.set(memoryKeys.page, pages.gameDetails);
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
    cardWidth: vpx(234)
    cardHeight: vpx(320)
    model: currentPlatform.games
    anchors.top: platformsList.bottom
    anchors.left: platformsList.left
    anchors.right: parent.right
    anchors.leftMargin: vpx(3)
    anchors.topMargin: vpx(24)
    delegate: Item {
      Rectangle {
        color: 'Gray'
        width: parent.width
        height: parent.height
      }

      Image {
        width: parent.width
        height: parent.height
        source: modelData.assets.poster
        asynchronous: true
        mipmap: true
      }
    }
  }

  Text {
    text: `${gamesList.currentIndex + 1} of ${currentPlatform.games.count}  |  ${currentGame.title}`
    anchors.top: gamesList.bottom
    anchors.topMargin: vpx(9)
    anchors.left: parent.left
    anchors.leftMargin: vpx(95)
    font.family: convectionui.name
    font.pointSize: vpx(14)
    layer.enabled: true
    color: "#616161"
    layer.effect: DropShadow {
      verticalOffset: vpx(1)
      horizontalOffset: vpx(1)
      color: "#55FFFFFF"
      radius: 1
      samples: vpx(1)
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
    button: "y"
    text: "Game details"
    anchors.left: selectPrompt.right
    anchors.leftMargin: vpx(21)
    anchors.verticalCenter: selectPrompt.verticalCenter
  }
}
