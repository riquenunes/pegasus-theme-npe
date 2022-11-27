import QtQuick 2.8
import "../js/enums.mjs" as Enums

Loader {
  id: pageLoader
  focus: true
  asynchronous: true
  anchors.fill: parent

  readonly property var pages: {
    "library": {
      path: "library/LibraryPage.qml",
      showStage: true
    },
    "gameDetails": {
      path: "details/DetailsPage.qml",
      showStage: false
    },
    "videoPlayer": {
      path: "video-player/VideoPlayerPage.qml",
      showStage: false
    },
    "imageViewer": {
      path: "image-viewer/ImageViewerPage.qml",
      showStage: false
    }
  }

  function navigate(page, params) {
    api.memory.set(Enums.MemoryKeys.Page, page);

    if (params) {
      const key = Object.keys(params)[0];
      const value = params[key];

      api.memory.set(key, value);
    }

    delay(() => {
      stage.state = page.showStage ? "Visible" : "Invisible";
      pageLoader.source = `../pages/${page.path}`;
    }, 240); // delay page change until button press animation and sound is complete
             // if actions to be executed by the buttons are moved to ButtonPrompt
             // we can implement this there
  }

  Component.onCompleted: {
    if (!api.memory.has(Enums.MemoryKeys.Page)) {
      navigate(pages.library);
    } else {
      navigate(api.memory.get(Enums.MemoryKeys.Page));
    }
  }
}
