import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15

Row {
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  anchors.leftMargin: vpx(96)
  anchors.bottomMargin: vpx(54)
  spacing: vpx(21)

  ButtonPrompt {
    id: bottomButton
    button: actionKeys.bottom
    text: availableActions[actionKeys.bottom].label || ''
    state: availableActions[actionKeys.bottom].visible ? 'Visible' : 'Invisible'
  }

  ButtonPrompt {
    id: rightButton
    button: actionKeys.right
    text: availableActions[actionKeys.right].label || ''
    state: availableActions[actionKeys.right].visible ? 'Visible' : 'Invisible'
  }

  ButtonPrompt {
    id: leftButton
    button: actionKeys.left
    text: availableActions[actionKeys.left].label || ''
    state: availableActions[actionKeys.left].visible ? 'Visible' : 'Invisible'
  }

  ButtonPrompt {
    button: actionKeys.top
    text: availableActions[actionKeys.top].label || ''
    state: availableActions[actionKeys.top].visible ? 'Visible' : 'Invisible'
  }
}
