import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

FloatingWindow {
    id: root

    // TODO: Find an image to set
    readonly property string imagePath: "file:///home/chrysanthemum/.config/waybar/scripts/sierra.jpg"

    function show() {
        root.visible = true;
    }

    color: "#f6f6f6"
    implicitHeight: 315
    implicitWidth: 510
    maximumSize: Qt.size(510, 315)
    minimumSize: Qt.size(510, 315)
    title: "About This Laptop"
    visible: false

    /* Content */
    RowLayout {
        anchors.bottomMargin: 16
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        /* Left: circular image */
        Item {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: 140
            Layout.preferredWidth: 140
            Layout.topMargin: 10

            ClippingRectangle {
                id: imgContainer

                anchors.fill: parent
                clip: true
                radius: 70

                Image {
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectCrop
                    height: parent.height
                    mipmap: true
                    smooth: true
                    source: root.imagePath
                    width: parent.width
                }
            }

            // Circular border
            Rectangle {
                anchors.fill: parent
                border.color: Qt.rgba(180 / 255, 180 / 255, 185 / 255, 0.47)
                border.width: 2
                color: "transparent"
                radius: 70
            }
        }

        /* Right: info column */
        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 2

            //TODO: Make a script to scrape data to display
            Text {
                color: "#1a1a1a"
                font.letterSpacing: -0.5
                font.pixelSize: 20
                font.weight: Font.DemiBold
                text: "NixOS"
            }
            Text {
                color: "#666666"
                font.pixelSize: 12
                text: "26.11 (Zokor)"
            }
            Item {
                Layout.preferredHeight: 10
            }

            /* Model */
            Text {
                Layout.fillWidth: true
                color: "#1a1a1a"
                font.pixelSize: 12
                text: "G3 3500"
                wrapMode: Text.WordWrap
            }
            Item {
                Layout.preferredHeight: 4
            }

            /* Spec rows */
            SpecRow {
                label: "Processor"
                value: "Intel i5-10300H @ 4.50 GHz"
            }
            SpecRow {
                label: "Memory"
                value: "32GB DDR4"
            }
            /*
			SpecRow {
                label: "Startup Disk"
                value: "NVMe Storage"
			}
			*/
            SpecRow {
                label: "Graphics"
                value: "NVIDIA GeForce GTX 1650 Mobile"
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }

    /* Bottom row: buttons + copyright */
    ColumnLayout {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            AboutButton {
                text: "System Report..."
            }
            AboutButton {
                text: "Software Update..."
            }
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            color: "#888888"
            font.pixelSize: 10
            text: "Credits: Luyu-wu/Config and c6rg0/System"
        }
    }

    /* Reusable button */
    component AboutButton: Rectangle {
        property alias text: btnLabel.text

        border.color: "#b0b0b0"
        border.width: 1
        implicitHeight: 24
        implicitWidth: 130
        radius: 4

        gradient: Gradient {
            GradientStop {
                color: btnMouse.pressed ? "#d0d0d0" : (btnMouse.containsMouse ? "#ffffff" : "#f5f5f5")
                position: 0.0
            }
            GradientStop {
                color: btnMouse.pressed ? "#e8e8e8" : (btnMouse.containsMouse ? "#ebebeb" : "#e0e0e0")
                position: 1.0
            }
        }
        Behavior on gradient {
            enabled: !btnMouse.pressed

            ColorAnimation {
                duration: 80
            }
        }

        Text {
            id: btnLabel

            anchors.centerIn: parent
            color: "#1a1a1a"
            font.pixelSize: 12
        }
        MouseArea {
            id: btnMouse

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
        }
    }

    /* Reusable spec row */
    component SpecRow: RowLayout {
        required property string label
        property alias value: valueText.text
        property Component valueComponent: null

        Layout.bottomMargin: 1
        Layout.topMargin: 1
        spacing: 4

        Text {
            Layout.preferredWidth: 110
            color: "#555555"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignRight
            text: parent.label
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: valueText

            Layout.fillWidth: true
            color: "#1a1a1a"
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            visible: !parent.valueComponent
            wrapMode: Text.WordWrap
        }
        Loader {
            Layout.fillWidth: true
            sourceComponent: parent.valueComponent
            visible: !!parent.valueComponent
        }
    }
}
