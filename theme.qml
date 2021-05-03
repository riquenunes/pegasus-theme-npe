
import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "components"

FocusScope {
  id: root
  FontLoader { id: convectionui; source: "assets/fonts/convectionui.ttf" }

  property int artworkWidth: vpx(234)
  property int artworkHeight: vpx(320)

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
      id: artwork
      width: artworkWidth
      height: artworkHeight
      scale: PathView.itemScale
      transformOrigin: Item.Left
      opacity: 1
      z: -x
      anchors.top: parent.top
      transform: Translate {
        y: artwork.PathView.itemOffsetY
      }

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
          width: width
          height: height
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
        radius: vpx(7)
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

  Keys.onUpPressed: {
    sectionsList.incrementCurrentIndex()
    generatePathPoints({
      parent: cardsList,
      itemWidth: artworkWidth,
      itemHeight: artworkHeight,
      itemsCount: cardsList.pathItemCount
    })
  }

  Keys.onDownPressed: {
    sectionsList.decrementCurrentIndex()
    generatePathPoints({
      parent: cardsList,
      itemWidth: artworkWidth,
      itemHeight: artworkHeight,
      itemsCount: cardsList.pathItemCount
    })
  }

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

  property var startingItemX: artworkWidth / 2;

  function generatePathPoints({
    parent,
    itemWidth,
    itemHeight,
    itemsCount,
  }) {
    const getScale = (index) => [
      1, .85938, .7531, .666, .600, .54688, .503, .4656, .42813, .403125, .375, .353125, .334375, .32, .32
    ][index];

    const getOffsetY = (index) => vpx([
      0, -4, -7, -9, -11, -13, -14, -15, -16, -17, -17, -18, -19, -19, -19
    ][index]);

    const getX = (index) => {
      const distances = [0, -2, -27, -39, -48, -52, -54, -55, -54, -55, -52, -52, -50, -50,-50];
      const startingItemX = itemWidth / 2;

      if (index === 0) return startingItemX;

      const currentWidth = itemWidth * getScale(index);
      const previousWidth = itemWidth * getScale(index - 1);
      const previousX = getX(index - 1);

      return previousWidth + previousX + vpx(distances[index]);
      return previousWidth + previousX - ((previousWidth - currentWidth) / 2) + vpx(distances[index]);
    }

    const createQtQuickObject = definition => Qt.createQmlObject(`
      import QtQuick 2.8;
      ${definition}
    `, root);

    const path = createQtQuickObject('Path { startX: 0; startY: 0 }');

    path.pathElements = [...Array(itemsCount + 1).keys()]
      .reduce((acc, i) => ([
        ...acc,
        `PathLine { x: ${getX(i)}; y: 0 }`,
        `PathAttribute { name: "itemScale"; value: ${getScale(i)} }`,
        `PathAttribute { name: "itemOffsetY"; value: ${getOffsetY(i)} }`,
        `PathPercent { value: ${1 / itemsCount * i}  }`
      ]), [
        `PathAttribute { name: "itemScale"; value: 1 }`
      ]).map(createQtQuickObject);

    parent.path = path;
    parent.visible = true;
  }

  PathView {
    visible: false
    id: cardsList
    anchors.top: sectionsList.bottom
    anchors.left: sectionsList.left
    anchors.right: parent.right
    anchors.leftMargin: vpx(3)
    anchors.topMargin: vpx(24)
    height: vpx(320)
    model: currentPlatform.games
    delegate: cardDelegate
    pathItemCount: currentPlatform.games.count < 14
      ? currentPlatform.games.count
      : 14
    movementDirection: PathView.Positive

    Component.onCompleted: {
      generatePathPoints({
        parent: cardsList,
        itemWidth: artworkWidth,
        itemHeight: artworkHeight,
        itemsCount: cardsList.pathItemCount
      })
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
