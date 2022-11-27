// all dimensions used in this theme are based on the original dimensions
// of Xbox 360 screenshots in its native resolution (1280x720), so this is
// a helper function to convert these measurements to the equivalent on whatever
// res the user is currently running on
export const vpx = screenHeight => (size, round = true) => {
  const result = size * (screenHeight / 720);
  if (round) {
    return Math.round(result);
  }

  return result;
}

export const delay = rootComponent => (cb, delayTime) => {
  function Timer() {
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", rootComponent);
  }

  const timer = new Timer();
  timer.interval = delayTime;
  timer.repeat = false;
  timer.triggered.connect(cb);
  timer.start();
}
