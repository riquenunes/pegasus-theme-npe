import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "../scripts/QmlObjectBuilder.mjs" as QmlObjectBuilder
import "../scripts/XboxDashboardParameters.mjs" as XboxDashboardParameters

PathView {
  id: panelsList
  interactive: false
  height: panelHeight + panelReflectionSize
  highlightMoveDuration: 400
  pathItemCount: model.count

  property var lastChild: children[children.length - 1]
  property int previousIndex: 0
  property real panelWidth
  property real panelHeight
  property var panelContent
  property var indexPersistenceKey

  function nextItem() {
    if (interactive && currentIndex < model.count - 1) incrementCurrentIndex();
  }

  function previousItem() {
    if (interactive && currentIndex > 0) decrementCurrentIndex();
  }

  function navigateForwardQuickly() {
    if (interactive) {
      for(let i = 0; i < 5; i++) {
        nextItem();
      }
    }
  }

  function navigateBackwardsQuickly() {
    if (interactive) {
      for(let i = 0; i < 5; i++) {
        previousItem();
      }
    }
  }

  onModelChanged: {
    if (model.count > 1) {
      panelUnfoldSound.play();
    }
  }

  onCurrentItemChanged: {
    if (currentIndex !== previousIndex) {
      if (currentIndex > previousIndex) panelRightSound.play();
      if (currentIndex < previousIndex) panelLeftSound.play();

      api.memory.set(indexPersistenceKey, currentIndex);
    }

    previousIndex = currentIndex;
  }

  Connections {
    target: lastChild

    function onXChanged() {
       maskContent.width = lastChild.x + lastChild.width * lastChild.scale
    }
  }

  onPathChanged: {
    interactive = false;
    delay(() => {
      currentIndex = api.memory.get(indexPersistenceKey);
      interactive = true;
    }, 50 * pathItemCount);
  }

  function generatePath() {
    const startingItemX = panelWidth / 2;
    const getScale = screenIndex => XboxDashboardParameters.panelScaleByScreenIndex[screenIndex];
    const getOffsetY = screenIndex => vpx(XboxDashboardParameters.panelYOffsetByScreenIndex[screenIndex]);
    const getX = (screenIndex) => {
      if (screenIndex === 0) return startingItemX;

      const currentWidth = panelWidth * getScale(screenIndex);
      const previousWidth = panelWidth * getScale(screenIndex - 1);
      const previousX = getX(screenIndex - 1);

      return previousWidth + previousX + vpx(XboxDashboardParameters.panelXOffsetByScreenIndex[screenIndex]);
    }

    const itemsCount = panelsList.pathItemCount
    const path = new QmlObjectBuilder.Path({ startX: 0, startY: 0 }, root);
    const buildPathSegment = (parameters, previousParameters = parameters) => {
      const { x, scale, yOffset, screenIndex } = parameters;
      const segment = [
        new QmlObjectBuilder.PathAttribute({ name: 'itemScale', value: scale }, root),
        new QmlObjectBuilder.PathAttribute({ name: 'itemOffsetY', value: yOffset }, root),
        new QmlObjectBuilder.PathAttribute({ name: 'previousItemScale', value: previousParameters.scale }, root),
        new QmlObjectBuilder.PathAttribute({ name: 'itemX', value: x }, root),
        new QmlObjectBuilder.PathAttribute({ name: 'previousItemX', value: previousParameters.x }, root),
        new QmlObjectBuilder.PathAttribute({ name: 'screenIndex', value: screenIndex }, root)
      ];

      return segment;
    }

    path.pathElements = [...Array(itemsCount + 1).keys()]
      .reduce((acc, i) => ([
        ...acc,
        {
          x: getX(i),
          y: 0,
          scale: getScale(i),
          yOffset: getOffsetY(i),
          screenIndex: i,
          percent: 1 / itemsCount * i
        }
      ]), [])
      .reduce(
        (acc, currentSegmentParameters, index, allParameters) => {
          const previousIndex = index - 1;
          const previousSegmentParameters = allParameters[previousIndex];

          return [
            ...acc,
            new QmlObjectBuilder.PathLine({ x: currentSegmentParameters.x, y: currentSegmentParameters.y }, root),
            ...buildPathSegment(currentSegmentParameters, previousSegmentParameters),
            new QmlObjectBuilder.PathPercent({ value: currentSegmentParameters.percent }, root),
          ]
        },
        buildPathSegment({ x: 0, scale: 1, yOffset: 0, screenIndex: 0 }),
      );

    return path;
  }

  Item {
    id: mask
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    height: root.height
    visible: false

    Rectangle {
      id: maskContent
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: vpx(400)
      color: "#FFFFFFFF"
    }
  }

  layer.enabled: true
  layer.effect: OpacityMask {
    maskSource: mask
  }

  path: generatePath();
}
