import QtQuick 2.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.12
import QtQml 2.15

import "../components"

Item {
  FontLoader { id: convectionui; source: "../assets/fonts/convectionui.ttf" }
  property var currentGame: api.memory.get(memoryKeys.currentGame)
  property var screenshotPath: currentGame.assets.background
      || currentGame.assets.banner
      || currentGame.assets.screenshot
      || currentGame.assets.titlescreen

  focus: true

  Image {
    source: screenshotPath
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
  }

  Keys.onLeftPressed: cardsList.decrementCurrentIndex()
  Keys.onRightPressed: cardsList.incrementCurrentIndex()

  CardsList {
    id: cardsList
    cardWidth: vpx(450)
    cardHeight: vpx(480)
    model: ListModel {
      ListElement {
        type: "quick-actions"
      }
      ListElement {
        type: "images"
      }
      ListElement {
        type: "details"
      }
      ListElement {
        type: "description"
      }
    }
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: vpx(67)

    delegate: Item {
      Rectangle {
        width: parent.width
        height: parent.height

        gradient: Gradient {
          GradientStop { position: 0.0; color: "#465052" }
          GradientStop { position: 1.0; color: "#1a1e1d" }
        }

        Item {
          visible: modelData.type === "quick-actions"
          anchors.fill: parent
          anchors.leftMargin: vpx(25)
          anchors.topMargin: vpx(25)
          anchors.rightMargin: vpx(25)
          anchors.bottomMargin: vpx(25)

          Connections {
            target: cardsList
            onCurrentIndexChanged: {
              if (isCurrentItem) {
                quickActions.forceActiveFocus()
              }
            }
          }

          Text {
            id: gameTitle
            text: currentGame.title
            color: "#FFF"
            font.pointSize: vpx(25)
            font.family: convectionui.name
          }

          Rating {
            id: rating
            rating: currentGame.rating
            anchors.topMargin: vpx(35)
            anchors.top: gameTitle.bottom
            anchors.right: parent.right
          }

          ListView {
            id: quickActions
            anchors.top: rating.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            highlight: Item {
              height: quickActions.currentItem.height + vpx(5)
              width: quickActions.currentItem.width + vpx(5)
              y: quickActions.currentItem.y - vpx(2.5)
              x: quickActions.currentItem.x - vpx(2.5)

              Rectangle {
                id: bg
                gradient: Gradient {
                  GradientStop { position: 0; color: "#bdd3a1" }
                  GradientStop { position: .5; color: "#5d9809" }
                  GradientStop { position: 1; color: "#6d9a17" }
                }
                radius: 5
                anchors.fill: parent
                clip: true

                RadialGradient {
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.verticalCenter: parent.bottom
                  height: parent.height
                  // opacity: .8
                  gradient: Gradient {
                    GradientStop { position: 0.0; color: "#66ffffff" }
                    GradientStop { position: 0.5; color: "transparent" }
                  }
                }

                // LinearGradient {
                //   id: glow
                //   width: vpx(160)
                //   height: vpx(160)
                //   anchors.verticalCenter: parent.verticalCenter

                //   x: 0
                //   start: Qt.point(0, 0)
                //   end: Qt.point(vpx(160), vpx(160))
                //   opacity: .3

                //   NumberAnimation on x {
                //     from: bg.width
                //     to: -width
                //     duration: 4000
                //     loops: Animation.Infinite
                //   }

                //   gradient: Gradient {
                //     GradientStop {
                //       position: .3
                //       color: "transparent"
                //     }
                //     GradientStop {
                //       position: .5
                //       color: "white"
                //     }
                //     GradientStop {
                //       position: .7
                //       color: "transparent"
                //     }
                //   }
                // }

              }
              DropShadow {
                anchors.fill: bg
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: bg
              }

            }
            highlightFollowsCurrentItem: false

            model: ListModel {
              ListElement {
                label: () => "Play Now"
                action: () => currentGame.launch()
                canExecute: () => true
              }
              ListElement {
                label: () => "Watch Preview"
                action: () => navigate(pages.videoPlayer, { [memoryKeys.videoPath]: currentGame.assets.video })
                canExecute: () => !!currentGame.assets.video
              }
              ListElement {
                label: () => !currentGame.favorite ? "Pin to Home" : "Remove Pin"
                action: () => currentGame.favorite = !currentGame.favorite
                canExecute: () => true
              }
            }
            delegate: Item {
              width: parent.width
              height: vpx(45)
              opacity: canExecute() ? 1 : .3

              Text {
                text: label()
                color: "#FFF"
                font.pointSize: vpx(18)
                font.family: convectionui.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: vpx(6)
                opacity: parent.ListView.isCurrentItem ? 1 : 0.7

                layer.enabled: true
                layer.effect: DropShadow {
                  verticalOffset: 1
                  horizontalOffset: 1
                  color: "#80000000"
                  radius: 2
                  samples: 3
                }
              }

              Rectangle {
                color: "#FFF"
                opacity: parent.ListView.isCurrentItem ? 0 : .2
                height: vpx(1)
                width: parent.width
                anchors.bottom: parent.bottom
              }

              Keys.onPressed: {
                if (!event.isAutoRepeat) {
                  if (api.keys.isAccept(event) && canExecute()) {
                    action();
                  }
                }
              }
            }
          }
        }

        Item {
          visible: modelData.type === "images"
          anchors.fill: parent
          anchors.leftMargin: vpx(25)
          anchors.topMargin: vpx(25)
          anchors.rightMargin: vpx(25)
          anchors.bottomMargin: vpx(25)
          Text {
            id: imagesHeader
            text: "Images"
            color: "#FFF"
            font.pointSize: vpx(18)
            font.family: convectionui.name
            font.weight: Font.Black
          }
        }

        Item {
          visible: modelData.type === "details"
          anchors.fill: parent
          anchors.leftMargin: vpx(25)
          anchors.topMargin: vpx(25)
          anchors.rightMargin: vpx(25)
          anchors.bottomMargin: vpx(25)
          Text {
            id: detailsHeader
            text: "Details"
            color: "#FFF"
            font.pointSize: vpx(18)
            font.family: convectionui.name
            font.weight: Font.Black
          }

          Row {
            spacing: vpx(25)
            anchors.topMargin: vpx(25)
            anchors.top: detailsHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Image {
              width: vpx(156)
              source: currentGame.assets.poster || currentGame.assets.boxFront || currentGame.assets.logo
              asynchronous: true
              mipmap: true
              fillMode: Image.PreserveAspectFit

            }

            Column {
              spacing: vpx(12)

              Column {
                Text {
                  text: "Platform"
                  color: "#FFF"
                  font.pointSize: vpx(18)
                  font.family: convectionui.name
                  font.weight: Font.Black
                }

                Text {
                  text: currentGame.collections.get(0).name
                  color: "#FFF"
                  font.pointSize: vpx(18)
                  font.family: convectionui.name
                  font.weight: Font.Black
                  opacity: 0.5
                }
              }

              Column {
                Text {
                  text: "Developer"
                  color: "#FFF"
                  font.pointSize: vpx(18)
                  font.family: convectionui.name
                  font.weight: Font.Black
                }

                Text {
                  text: currentGame.developer
                  color: "#FFF"
                  font.pointSize: vpx(18)
                  font.family: convectionui.name
                  font.weight: Font.Black
                  opacity: 0.5
                }
              }

              Column {
                Text {
                  text: "Publisher"
                  color: "#FFF"
                  font.pointSize: vpx(18)
                  font.family: convectionui.name
                  font.weight: Font.Black
                  anchors.topMargin: vpx(25)
                }

                Text {
                  text: currentGame.publisher
                  color: "#FFF"
                  font.pointSize: vpx(18)
                  font.family: convectionui.name
                  font.weight: Font.Black
                  opacity: 0.5
                }
              }
            }
          }


        }

        Item {
          visible: modelData.type === "description"
          anchors.fill: parent
          anchors.leftMargin: vpx(25)
          anchors.topMargin: vpx(25)
          anchors.rightMargin: vpx(25)
          anchors.bottomMargin: vpx(25)
          Text {
            id: aboutHeader
            text: "About This Game"
            color: "#FFF"
            font.pointSize: vpx(18)
            font.family: convectionui.name
            font.weight: Font.Black
          }

          Text {
            color: "#FFF"
            font.pointSize: vpx(18)
            font.family: convectionui.name
            font.weight: Font.ExtraLight
            anchors.topMargin: vpx(25)
            anchors.top: aboutHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            wrapMode: Text.WordWrap
            text: currentGame.description || currentGame.summary
            textFormat: Text.StyledText
            opacity: 0.5
          }
        }
      }
    }
  }

  Keys.onPressed: {
    if (!event.isAutoRepeat) {
      if (api.keys.isCancel(event)) {
        navigate(pages.library);
        event.accepted = true;
      }
    }
  }

  ButtonPrompt {
    id: selectPrompt
    button: "a"
    text: "Select"
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: vpx(95)
    anchors.bottomMargin: vpx(55)
  }

  ButtonPrompt {
    button: "b"
    text: "Back"
    anchors.left: selectPrompt.right
    anchors.leftMargin: vpx(21)
    anchors.verticalCenter: selectPrompt.verticalCenter
  }
}
