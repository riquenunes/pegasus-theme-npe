
import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "components"

FocusScope {
  FontLoader { id: convectionui; source: "assets/fonts/convectionui.ttf" }

  function vpx(size) {
    return Math.round(size * (Screen.height / 720))
  }

  Image {
    source: "assets/images/wallpapers/0002.jpg"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Image {
    source: "assets/images/stages/0003.png"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Component {
    id: cardDelegate
    Item {
      width: vpx(234)
      height: vpx(320)
      scale: PathView.iconScale
      z: -x
      anchors.top: parent.top

      Image {
        id: poster
        width: parent.width
        height: parent.height
        source: modelData.assets.poster
        visible: modelData.assets.poster
        asynchronous: true
        mipmap: true
        layer.enabled: true
        layer.effect: OpacityMask {
          maskSource: mask
        }
        sourceSize: {
          width: vpx(234)
          height: vpx(320)
        }
      }

      Rectangle {
        id: fallback
        width: parent.width
        height: parent.height
        visible: !poster.visible

        Text {
          text: modelData.title
        }

        layer.enabled: true
        layer.effect: OpacityMask {
          maskSource: mask
        }
      }

      Rectangle {
        id: mask
        anchors.fill: parent
        radius: vpx(8)
        visible: false
      }

      Rectangle {
        id: reflection
        width: poster.width; height: poster.height
        anchors.top: poster.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        gradient: Gradient {
          GradientStop { position: 0; color: Qt.rgba(1,1,1,0.1) }
          GradientStop { position: 0.4; color: Qt.rgba(1,1,1,0) }
        }
      }

      ShaderEffect
      {
        property variant mask: ShaderEffectSource
        {
          sourceItem: reflection
          hideSource: true
        }

        property variant source: ShaderEffectSource
        {
          sourceItem: poster.visible ? poster : fallback
          hideSource: false
        }

        width: parent.width
        height: parent.height
        anchors.top: poster.bottom
        fragmentShader: `
        varying highp vec2 qt_TexCoord0;
        uniform sampler2D source;
        uniform sampler2D mask;
        void main(void)

        { gl_FragColor = texture2D(source, vec2(qt_TexCoord0.s, 1.0 - qt_TexCoord0.t)) * texture2D(mask, qt_TexCoord0).a; }
        `
      }

      Image {
        anchors.left: poster.right
        height: parent.height
        width: height * 0.09
        source: "assets/images/misc/card-shadow.png"
      }
    }
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

  property var currentPlatform: api.collections.get(sectionsList.currentIndex)
  property var currentGame: currentPlatform.games.get(cardsList.currentIndex)

  Keys.onUpPressed: sectionsList.decrementCurrentIndex()
  Keys.onDownPressed: sectionsList.incrementCurrentIndex()
  Keys.onLeftPressed: cardsList.decrementCurrentIndex()
  Keys.onRightPressed: cardsList.incrementCurrentIndex()
  Keys.onPressed: {
    if (!event.isAutoRepeat && api.keys.isAccept(event)) {
      currentGame.launch();
    }
  }
  focus: true

  PathView {
    id: sectionsList
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
      startX: 0; startY: sectionsList.height - 21
      PathAttribute { name: "itemScale"; value: 1 }
      PathAttribute { name: "itemOpacity"; value: 1 }
      PathLine { x: 0; y: 0 }
      PathAttribute { name: "itemScale"; value: 0.39 }
      PathAttribute { name: "itemOpacity"; value: 0.2 }
    }
  }

  PathView {
    id: cardsList
    anchors.top: sectionsList.bottom
    anchors.left: sectionsList.left
    anchors.right: parent.right
    anchors.leftMargin: vpx(234) / 2 + vpx(3) // extract to var
    anchors.topMargin: vpx(24)
    height: vpx(320)
    model: api.collections.get(sectionsList.currentIndex).games
    delegate: cardDelegate
    pathItemCount: 9

    movementDirection: PathView.Positive

    path: Path {
      startX: 0; startY: 0
      PathAttribute { name: "iconScale"; value: 1 }

      PathLine { x: vpx(207); y: 0 }
      PathPercent { value: 100 / 9 / 100 * 1  }
      PathAttribute { name: "iconScale"; value: 0.86 }

      PathLine { x: vpx(381); y: 0 }
      PathPercent { value: 100 / 9 / 100 * 2  }
      PathAttribute { name: "iconScale"; value: 0.75 }

      PathLine { x: vpx(534); y: 0 }
      PathPercent { value: 100 / 9 / 100 * 3  }
      PathAttribute { name: "iconScale"; value: 0.67 }

      PathLine { x: vpx(667); y: 0 }
      PathPercent { value: 100 / 9 / 100 * 4  }
      PathAttribute { name: "iconScale"; value: 0.6 }

      PathLine { x: vpx(787); y: 0 }
      PathPercent { value: 100 / 9 / 100 * 5  }
      PathAttribute { name: "iconScale"; value: 0.55 }

      PathLine { x: vpx(896); y: 0 }
      PathPercent { value: 100 / 9 / 100 * 6  }
      PathAttribute { name: "iconScale"; value: 0.50 }

      PathLine { x: vpx(993); y: 0 }
      PathPercent { value: 100 / 9 / 100 * 7  }
      PathAttribute { name: "iconScale"; value: 0.47 }

      PathLine { x: vpx(1082); y: 0 }
      PathPercent { value: 1  }
      PathAttribute { name: "iconScale"; value: 0.43 }
    }
  }

  Text {
    text: `${cardsList.currentIndex + 1} of ${cardsList.count}  |  ${currentGame.title}`
    anchors.top: cardsList.bottom
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
