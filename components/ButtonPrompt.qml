import QtQuick 2.8
import QtGraphicalEffects 1.0

Item {
  id: prompt
  property string button
  property string text
  width: icon.width + label.contentWidth + label.anchors.leftMargin
  height: icon.height
  property bool stateVisible: true

  Image {
    id: icon
    source: `../assets/images/buttons/${button}.png`
    width: vpx(32)
    height: vpx(32)
  }

  StyledText {
    id: label
    anchors.left: icon.right
    anchors.verticalCenter: icon.verticalCenter
    anchors.leftMargin: vpx(4)
    text: parent.text
    font.pointSize: vpx(14)
    transform: Translate {
      y: vpx(1)
    }
  }

  states: [
    State { name: 'Visible' },
    State { name: 'Invisible' }
  ]

  transitions: [
    Transition {
      to: 'Visible'
      SequentialAnimation {
        NumberAnimation {
          target: prompt
          property: 'width'
          to: icon.width + label.contentWidth + label.anchors.leftMargin
          duration: 100
        }
        ParallelAnimation {
          NumberAnimation {
            target: icon
            property: 'scale'
            to: 1
            duration: 300
            easing.type: Easing.OutBounce
          }
          NumberAnimation {
            target: label
            property: 'opacity'
            to: 1
            duration: 300
          }
        }
      }
    },
    Transition {
      to: 'Invisible'
      SequentialAnimation {
        ParallelAnimation {
          NumberAnimation {
            target: icon
            property: 'scale'
            to: 0
            duration: 300
          }
          NumberAnimation {
            target: label
            property: 'opacity'
            to: 0
            duration: 300
          }
        }
        NumberAnimation {
          target: prompt
          property: 'width'
          to: 0
          duration: 100
        }
      }
    }
  ]
}
