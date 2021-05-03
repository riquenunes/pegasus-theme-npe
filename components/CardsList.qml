import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

Item {
  property real cardWidth
  property real cardHeight
  height: cardHeight
  property Component delegate
  property alias model: cardsList.model
  property alias currentIndex: cardsList.currentIndex
  property var incrementCurrentIndex: cardsList.incrementCurrentIndex
  property var decrementCurrentIndex: cardsList.decrementCurrentIndex
  property var generatePathPoints: () => {
    const getScale = (index) => [
      1, .85938, .7531, .666, .600, .54688, .503, .4656, .42813, .403125, .375, .353125, .334375, .32, .32
    ][index];

    const getOffsetY = (index) => vpx([
      0, -4, -7, -9, -11, -13, -14, -15, -16, -17, -17, -18, -19, -19, -19
    ][index]);

    const getX = (index) => {
      const distances = [0, -2, -27, -39, -48, -52, -54, -55, -54, -55, -52, -52, -50, -50,-50];
      const startingItemX = cardWidth / 2;

      if (index === 0) return startingItemX;

      const currentWidth = cardWidth * getScale(index);
      const previousWidth = cardWidth * getScale(index - 1);
      const previousX = getX(index - 1);

      return previousWidth + previousX + vpx(distances[index]);
      return previousWidth + previousX - ((previousWidth - currentWidth) / 2) + vpx(distances[index]);
    }

    const createQtQuickObject = definition => Qt.createQmlObject(`
      import QtQuick 2.8;
      ${definition}
    `, root);

    const path = createQtQuickObject('Path { startX: 0; startY: 0 }');
    const itemsCount = cardsList.pathItemCount

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

    cardsList.path = path;
  }

  Component {
    id: cardDelegate
    Item {
      id: card
      width: cardWidth
      height: cardHeight
      scale: PathView.itemScale
      transformOrigin: Item.Left
      opacity: 1
      z: -x
      anchors.top: parent.top
      transform: Translate {
        y: card.PathView.itemOffsetY
      }

      Item {
        id: content
        property var modelData: model
        width: parent.width
        height: parent.height

        Loader {
          id: cardLoader
          property var modelData: parent.modelData
          width: parent.width
          height: parent.height
          sourceComponent: delegate
        }

        Rectangle {
          id: mask
          anchors.fill: parent
          radius: vpx(7)
          visible: false
        }

        layer.enabled: true
        layer.effect: OpacityMask {
          maskSource: mask
        }
      }


      Rectangle {
        id: reflection
        width: content.width
        height: content.height
        anchors.top: content.bottom
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
          sourceItem: content
          hideSource: false
        }

        width: parent.width
        height: parent.height
        anchors.top: content.bottom
        fragmentShader: `
        varying highp vec2 qt_TexCoord0;
        uniform sampler2D source;
        uniform sampler2D mask;
        void main(void)

        { gl_FragColor = texture2D(source, vec2(qt_TexCoord0.s, 1.0 - qt_TexCoord0.t)) * texture2D(mask, qt_TexCoord0).a; }
        `
      }

      Image {
        anchors.left: content.right
        height: parent.height
        width: height * 0.09
        source: "../assets/images/misc/card-shadow.png"
      }
    }
  }

  PathView {
    id: cardsList
    anchors.fill: parent
    pathItemCount: model.count < 14
      ? model.count
      : 14
    movementDirection: PathView.Positive
    delegate: cardDelegate

    Component.onCompleted: generatePathPoints()
  }
}
