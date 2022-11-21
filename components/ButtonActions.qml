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

  function onPressed(event) {
    if (!event.isAutoRepeat) {
      if (api.keys.isAccept(event)) {
        bottomButton.onPressed(event);
      } else if (api.keys.isCancel(event)) {
        rightButton.onPressed(event);
      } else if (api.keys.isDetails(event)) {
        leftButton.onPressed(event);
      } else if (api.keys.isFilters(event)) {
        topButton.onPressed(event);
      }
    }
  }

  ButtonPrompt {
    id: bottomButton
    button: actionKeys.bottom
    text: availableActions[actionKeys.bottom].label || ''
    enabled: availableActions[actionKeys.bottom].visible
    sound: selectSound
  }

  ButtonPrompt {
    id: rightButton
    button: actionKeys.right
    text: availableActions[actionKeys.right].label || ''
    enabled: availableActions[actionKeys.right].visible
    sound: backSound
  }

  ButtonPrompt {
    id: leftButton
    button: actionKeys.left
    text: availableActions[actionKeys.left].label || ''
    enabled: availableActions[actionKeys.left].visible
    sound: selectSound
  }

  ButtonPrompt {
    id: topButton
    button: actionKeys.top
    text: availableActions[actionKeys.top].label || ''
    enabled: availableActions[actionKeys.top].visible
    sound: selectSound
  }
}
