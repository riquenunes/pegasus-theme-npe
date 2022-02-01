import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

PathView {
  id: panelsList
  height: panelHeight
  pathItemCount: model.count < 14
    ? model.count
    : 14
  movementDirection: PathView.Positive

  property int previousIndex: 0
  property real panelWidth
  property real panelHeight
  property var panelContent
  property var indexPersistenceKey

  onCurrentItemChanged: {
    if (currentIndex !== previousIndex) {
      if (currentIndex > previousIndex) panelRightSound.play();
      if (currentIndex < previousIndex) panelLeftSound.play();

      api.memory.set(indexPersistenceKey, currentIndex);
    }

    previousIndex = currentIndex;
  }

  onModelChanged: {
    previousIndex = 0;
    // currentIndex = api.memory.get(indexPersistenceKey) || 0;
    // generatePathPoints();
  }

  Component.onCompleted: {
    // generatePathPoints();
    // delay(() => { currentIndex = api.memory.get(indexPersistenceKey) || 0 }, 1000);
  }

  onPathChanged: {
    currentIndex = api.memory.get(indexPersistenceKey)
  }

  // property Component delegate
  function generatePathPoints() {
    const getScale = (index) => [
      1, .85938, .7531, .666, .600, .54688, .503, .4656, .42813, .403125, .375, .353125, .334375, .32, .32
    ][index];

    const getOffsetY = (index) => vpx([
      0, -4, -7, -9, -11, -13, -14, -15, -16, -17, -17, -18, -19, -19, -19
    ][index]);

    const getX = (index) => {
      const distances = [0, -2, -27, -39, -48, -52, -54, -55, -54, -55, -52, -52, -50, -50,-50];
      const startingItemX = panelWidth / 2;

      if (index === 0) return startingItemX;

      const currentWidth = panelWidth * getScale(index);
      const previousWidth = panelWidth * getScale(index - 1);
      const previousX = getX(index - 1);

      return previousWidth + previousX + vpx(distances[index]);
      return previousWidth + previousX - ((previousWidth - currentWidth) / 2) + vpx(distances[index]);
    }

    const createQtQuickObject = definition => Qt.createQmlObject(`
      import QtQuick 2.8;
      ${definition}
    `, root);

    const path = createQtQuickObject('Path { startX: 0; startY: 0 }');
    const itemsCount = panelsList.pathItemCount

    path.pathElements = [...Array(itemsCount + 1).keys()]
      .reduce((acc, i) => ([
        ...acc,
        `PathLine { x: ${getX(i)}; y: 0 }`,
        `PathAttribute { name: 'itemScale'; value: ${getScale(i)} }`,
        `PathAttribute { name: 'itemOffsetY'; value: ${getOffsetY(i)} }`,
        `PathAttribute { name: 'previousItemScale'; value: ${getScale(i == 0 ? 0 : i - 1)} }`,
        `PathAttribute { name: 'itemX'; value: ${getX(i)} }`,
        `PathAttribute { name: 'previousItemX'; value: ${getX(i == 0 ? 0 : i - 1)} }`,
        `PathAttribute { name: 'screenIndex'; value: ${i} }`,
        `PathPercent { value: ${1 / itemsCount * i}  }`
      ]), [
        `PathAttribute { name: 'itemScale'; value: 1 }`,
        `PathAttribute { name: 'previousItemScale'; value: ${getScale(0)} }`,
        `PathAttribute { name: 'itemX'; value: ${getX(0)} }`,
        `PathAttribute { name: 'previousItemX'; value: ${getX(0)} }`,
        `PathAttribute { name: 'screenIndex'; value: 0 }`,
      ]).map(createQtQuickObject);

    return path;
  }

  path: generatePathPoints();
}
