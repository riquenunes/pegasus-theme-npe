import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15

Item {
  property real rating

  width: vpx(174)
  height: vpx(40)

  Row {
    spacing: vpx(6)
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    width: parent.width * parent.rating
    clip: true

    Image {
      source: '../assets/images/misc/star-filled.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-filled.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-filled.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-filled.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-filled.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-filled.png'
      width: vpx(24)
      height: vpx(24)
    }
  }

  Row {
    spacing: vpx(6)
    anchors.fill: parent

    Image {
      source: '../assets/images/misc/star-empty.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-empty.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-empty.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-empty.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-empty.png'
      width: vpx(24)
      height: vpx(24)
    }

    Image {
      source: '../assets/images/misc/star-empty.png'
      width: vpx(24)
      height: vpx(24)
    }
  }
}
