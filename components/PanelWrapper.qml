import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

FocusScope {
  id: panel
  width: parent.panelWidth
  height: parent.panelHeight
  scale: PathView.itemScale
  transformOrigin: Item.Left
  opacity: 0
  z: -x
  anchors.top: parent.top
  property int screenIndex: Math.round(panel.PathView.screenIndex)
  property int itemIndex: index
  default property alias content: wrapper.data
  transform: Translate {
    y: panel.PathView.itemOffsetY

    SequentialAnimation on x  {
      PauseAnimation { duration: 50 * screenIndex }
      NumberAnimation {
        from: -(panel.PathView.itemX - panel.PathView.previousItemX)
        to: 0
        duration: 300
        easing.type: Easing.OutCubic
      }
    }
  }

  SequentialAnimation on opacity  {
    PauseAnimation { duration: 50 * screenIndex }
    NumberAnimation {
      from: 0
      to: 1
      duration: 300
      easing.type: Easing.OutCubic
    }
  }

  SequentialAnimation on scale  {
    PauseAnimation { duration: 50 * screenIndex }
    NumberAnimation {
      from: panel.PathView.previousItemScale
      to: panel.PathView.itemScale
      duration: 300
      easing.type: Easing.OutCubic
    }
  }

  Item {
    id: content
    width: parent.width
    height: parent.height

    Item {
      id: wrapper
      width: parent.width
      height: parent.height
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
    {
      gl_FragColor = texture2D(source, vec2(qt_TexCoord0.s, 1.0 - qt_TexCoord0.t)) * texture2D(mask, qt_TexCoord0).a;
    }
    `
  }

  Image {
    anchors.left: content.right
    height: parent.height
    width: height * 0.09
    source: '../assets/images/misc/panel-shadow.png'
  }
}
