import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15

ListView {
  id: listView
  anchors.top: rating.bottom
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  anchors.right: parent.right

  property int previousIndex: 0

  onCurrentItemChanged: {
    if (currentIndex !== previousIndex) focusSound.play();

    setAvailableActions(Object.assign(availableActions, {
      [actionKeys.bottom]: {
        label: 'Select',
        visible: model.get(currentIndex).canExecute()
      }
    }));

    previousIndex = currentIndex;
  }

  onActiveFocusChanged: {
    if (activeFocus) {
      setAvailableActions(Object.assign(availableActions, {
        [actionKeys.bottom]: {
          label: 'Select',
          visible: model.get(currentIndex).canExecute()
        }
      }));
    }
  }

  highlight: Item {
    height: listView.currentItem.height + vpx(5)
    width: listView.currentItem.width + vpx(5)
    y: listView.currentItem.y - vpx(2.5)
    x: listView.currentItem.x - vpx(2.5)

    Rectangle {
      visible: !listView.activeFocus
      anchors.fill: parent
      color: 'Transparent'
      border.color: '#FFF'
      border.width: vpx(2)
      opacity: .2
      radius: bg.radius
    }

    Rectangle {
      id: bg
      visible: listView.activeFocus
      gradient: Gradient {
        GradientStop { position: 0; color: '#bdd3a1' }
        GradientStop { position: .5; color: '#5d9809' }
        GradientStop { position: 1; color: '#6d9a17' }
      }
      radius: vpx(5)
      anchors.fill: parent

      RadialGradient {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.bottom
        height: parent.height
        gradient: Gradient {
          GradientStop { position: 0.0; color: '#66ffffff' }
          GradientStop { position: 0.5; color: 'transparent' }
        }
      }

      layer.enabled: true
      layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0
        samples: 17
        color: '#80000000'
      }
    }

    Rectangle {
      anchors.fill: parent
      radius: bg.radius
      visible: bg.visible
      color: 'transparent'
      clip: true

      LinearGradient {
        id: glow
        height: (parent.height < parent.width ? parent.height : parent.width) * 3
        width: height
        anchors.verticalCenter: parent.verticalCenter

        x: 0
        start: Qt.point(0, height - (height / 4))
        end: Qt.point(width - (width / 4), height)
        opacity: .2

        NumberAnimation on x {
          running: parent.visible
          from: parent.width
          to: -parent.width - width
          duration: 4000
          loops: Animation.Infinite
        }

        gradient: Gradient {
          GradientStop {
            position: 0
            color: 'transparent'
          }
          GradientStop {
            position: .5
            color: 'white'
          }
          GradientStop {
            position: 1
            color: 'transparent'
          }
        }
      }
    }
  }
  highlightFollowsCurrentItem: false
  delegate: Item {
    width: parent.width
    height: vpx(45)
    opacity: canExecute() ? 1 : .3

    StyledText {
      text: label()
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: vpx(6)
      opacity: parent.ListView.isCurrentItem ? 1 : 0.7
    }

    Rectangle {
      color: '#FFF'
      opacity: parent.ListView.isCurrentItem ? 0 : .2
      height: vpx(1)
      width: parent.width
      anchors.bottom: parent.bottom
    }

    Keys.onPressed: {
      if (
        !event.isAutoRepeat &&
        api.keys.isAccept(event) &&
        canExecute()
      ) {
        action();
      }
    }
  }
}
