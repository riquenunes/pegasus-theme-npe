import QtQuick 2.8

Image {
  property string stageName

  id: stage
  source: `../assets/images/stages/${stageName}.png`
  fillMode: Image.PreserveAspectCrop
  anchors.fill: parent
  opacity: 0
  anchors.topMargin: vpx(30)

  states: [
    State { name: "Visible"; when: enabled },
    State { name: "Invisible"; when: !enabled }
  ]

  transitions: [
    Transition {
      to: "Visible"
      ParallelAnimation {
        NumberAnimation {
          target: stage
          property: "anchors.topMargin"
          to: 0
          duration: 100
        }
        NumberAnimation {
          target: stage
          property: "opacity"
          to: 1
          duration: 200
        }
      }
    },
    Transition {
      to: "Invisible"
      ParallelAnimation {
        NumberAnimation {
          target: stage
          property: "anchors.topMargin"
          to: vpx(30)
          duration: 100
        }
        NumberAnimation {
          target: stage
          property: "opacity"
          to: 0
          duration: 200
        }
      }
    }
  ]
}
