import QtQuick.Particles 2.0
import QtQuick 2.8

Item {
  property string wallpaperName
  anchors.fill: parent

  Image {
    id: backgroundImage
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
    source: `../assets/images/wallpapers/${wallpaperName}.png`
  }

  ParticleSystem {
    id: particleSystem
  }

  Emitter {
    anchors.right: parent.right
    anchors.top: parent.top
    width: parent.width * .8
    height: parent.height * .8
    system: particleSystem
    emitRate: 2
    lifeSpan: 10000
    lifeSpanVariation: 4000
    size: vpx(32)
    endSize: vpx(128)
    sizeVariation: vpx(128)
    velocity: AngleDirection {
      angle: 320
      angleVariation: 20
      magnitude: 25
      magnitudeVariation: 5
    }

  }

  ItemParticle {
    system: particleSystem
    opacity: .15

    delegate: Image {
      width: vpx(256)
      height: width
      NumberAnimation on scale {
        from: Math.random() * 0.125;
        to: Math.random() * (1 - 0.125) + 0.125;
        duration: 14000;
      }
      source: `../assets/images/bgrings/bg_ring${Math.ceil(Math.random()*4)}.png`
    }
  }
}
