const createQtQuickObject = (definition, root) => Qt.createQmlObject(`
  import QtQuick 2.8; ${definition}
`, root);

export function Path({ startX, startY }, root) {
  return createQtQuickObject(`Path { startX: ${startX}; startY: ${startY} }`, root);
}

export function PathLine({ x, y }, root) {
  return createQtQuickObject(`PathLine { x: ${x}; y: ${y} }`, root);
}

export function PathAttribute({ name, value }, root) {
  return createQtQuickObject(`PathAttribute { name: "${name}"; value: ${value} }`, root);
}

export function PathPercent({ value }, root) {
  return createQtQuickObject(`PathPercent { value: ${value} }`, root);
}
