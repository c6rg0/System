import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import qs.share.app
import "components"

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData

        WlrLayershell.layer: HyprlandExt.exposeOpen ? WlrLayer.Overlay : WlrLayer.Top
        anchors.left: true
        anchors.right: true
        anchors.top: true
        color: "transparent"
        exclusiveZone: 50
        implicitHeight: 56  // 40px bar + 16px shadow
        screen: modelData

        Variables {
            id: v
        }

        /* Shadow gradient below the bar */
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: 16

            gradient: Gradient {
                GradientStop {
                    color: Qt.rgba(0, 0, 0, 0.15)
                    position: 0.0
                }
                GradientStop {
                    color: Qt.rgba(0, 0, 0, 0.0)
                    position: 1.0
                }
            }
        }

        /* Bar background */
        Rectangle {
            id: barBackground

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            //color: "#d1e4e7ef"
            color: v.barBackground
            implicitHeight: 40

            RowLayout {
                spacing: 0

                anchors {
                    bottomMargin: 1
                    fill: parent
                }

                /* Left */
                Logo {
                }
                WindowTitle {
                }

                /* Spacer */
                Item {
                    Layout.fillWidth: true
                }

                /* Right */
                TrayWidget {
                }
                MprisWidget {
                }
                VolumeWidget {
                }
                BluetoothWidget {
                }
                BatteryWidget {
                }
                NetworkWidget {
                }
                Clock {
                }
            }

            /* Bottom border */
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: v.barBorder
                implicitHeight: 1
            }
        }
    }
}
