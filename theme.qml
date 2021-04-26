
import QtQuick 2.8
import QtGraphicalEffects 1.0
import "components"

FocusScope {
  FontLoader { id: convectionui; source: "assets/fonts/convectionui.ttf" }

  function vpx(value) {
    return value
  }

  Image {
    source: "assets/images/wallpapers/0001.jpg"
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
      width: height * 0.75
      height: 480
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
        layer.enabled: true
        layer.effect: OpacityMask {
          maskSource: mask
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
        radius: 8
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
      // scale: PathView.itemScale
      opacity: PathView.itemOpacity
      z: index
      text: modelData.name
      color: '#FFF'
      font.pointSize: 44
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
        verticalOffset: 1
        horizontalOffset: 1
        color: "#000"
        radius: 2
        samples: 3
      }
    }
  }

  Keys.onUpPressed: sectionsList.decrementCurrentIndex()
  Keys.onDownPressed: sectionsList.incrementCurrentIndex()
  Keys.onLeftPressed: cardsList.decrementCurrentIndex()
  Keys.onRightPressed: cardsList.incrementCurrentIndex()
  Keys.onPressed: {
    if (!event.isAutoRepeat && api.keys.isAccept(event)) {
      api.collections.get(sectionsList.currentIndex).games.get(cardsList.currentIndex).launch();
    }
  }
  focus: true

  PathView {
    id: sectionsList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.leftMargin: vpx(118)
    anchors.topMargin: vpx(100)
    height: vpx(242)
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
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: vpx(300)
    anchors.topMargin: vpx(40)
    model: api.collections.get(sectionsList.currentIndex).games
    delegate: cardDelegate
    pathItemCount: 9

    movementDirection: PathView.Positive

    path: Path {
      startX: 0; startY: 0
      // PathQuad { x: 50; y: 80; controlX: 0; controlY: 80 }
      // PathPercent { value: 0.1 } 10% no path quad anterior
      // PathLine { x: 150; y: 80 }
      // PathPercent { value: 0.75 }
      // PathQuad { x: 180; y: 0; controlX: 200; controlY: 80 }
      // PathPercent { value: 1 }
      PathAttribute { name: "iconScale"; value: 1 }

      PathLine { x: 311; y: 0 }
      PathPercent { value: 100 / 9 / 100 * 1  }
      PathAttribute { name: "iconScale"; value: 0.83 }

      PathLine { x: 571; y: 0 }
      PathPercent { value: 100 / 9 / 100 * 2  }
      PathAttribute { name: "iconScale"; value: 0.73 }

      PathLine { x: 801; y: 0 }
      PathPercent { value: 100 / 9 / 100 * 3  }
      PathAttribute { name: "iconScale"; value: 0.65 }

      PathLine { x: 1000; y: 0 }
      PathPercent { value: 100 / 9 / 100 * 4  }
      PathAttribute { name: "iconScale"; value: 0.6 }

      PathLine { x: 1181; y: 0 }
      PathPercent { value: 100 / 9 / 100 * 5  }
      PathAttribute { name: "iconScale"; value: 0.54 }

      PathLine { x: 1344; y: 0 }
      PathPercent { value: 100 / 9 / 100 * 6  }
      PathAttribute { name: "iconScale"; value: 0.49 }

      PathLine { x: 1490; y: 0 }
      PathPercent { value: 100 / 9 / 100 * 7  }
      PathAttribute { name: "iconScale"; value: 0.45 }

      PathLine { x: 1623; y: 0 }
      PathPercent { value: 1  }
      PathAttribute { name: "iconScale"; value: 0.42 }

    }
  }

  ButtonPrompt {
    id: selectPrompt
    button: "a"
    text: "Select"
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: vpx(118)
    anchors.bottomMargin: vpx(82)
  }

  ButtonPrompt {
    button: "y"
    text: "Game details"
    anchors.left: selectPrompt.right
    anchors.leftMargin: vpx(30)
    anchors.verticalCenter: selectPrompt.verticalCenter
  }
}
