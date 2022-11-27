import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15
import "../js/enums.mjs" as Enums

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

  function setAvailableActions(replacementActions) {
    const newActions = Object.values(Enums.ActionKeys).reduce((newActions, key) => {
      if (replacementActions[key]) {
        newActions[key] = replacementActions[key];
      } else {
        newActions[key] = {
          visible: false,
          label: internal.availableActions[key]
            ? internal.availableActions[key].label
            : undefined
        };
      }

      return newActions;
    }, {})

    internal.availableActions = newActions;
  }

  function appendAdditionalAvailableActions(newActions) {
    setAvailableActions(Object.assign(internal.availableActions, newActions))
  }

  ButtonPrompt {
    id: bottomButton
    button: Enums.ActionKeys.Bottom
    text: internal.availableActions[Enums.ActionKeys.Bottom].label || ""
    enabled: internal.availableActions[Enums.ActionKeys.Bottom].visible
    sound: selectSound
  }

  ButtonPrompt {
    id: rightButton
    button: Enums.ActionKeys.Right
    text: internal.availableActions[Enums.ActionKeys.Right].label || ""
    enabled: internal.availableActions[Enums.ActionKeys.Right].visible
    sound: backSound
  }

  ButtonPrompt {
    id: leftButton
    button: Enums.ActionKeys.Left
    text: internal.availableActions[Enums.ActionKeys.Left].label || ""
    enabled: internal.availableActions[Enums.ActionKeys.Left].visible
    sound: selectSound
  }

  ButtonPrompt {
    id: topButton
    button: Enums.ActionKeys.Top
    text: internal.availableActions[Enums.ActionKeys.Top].label || ""
    enabled: internal.availableActions[Enums.ActionKeys.Top].visible
    sound: selectSound
  }

  QtObject {
    id: internal
    property var availableActions
  }

  Component.onCompleted: {
    internal.availableActions = {
      [Enums.ActionKeys.Bottom]: { visible: true },
      [Enums.ActionKeys.Right]: { visible: true },
      [Enums.ActionKeys.Left]: { visible: true },
      [Enums.ActionKeys.Top]: { visible: true }
    };
  }
}
