/*
 * TODO, Optimise:
 * This module interupts the UI until a list of connectable
 * networks is gathered. Ideally, it should show the popup
 * immediately and allow the disruption of its further
 * loading.
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Networking
import qs.share.menu
import "../.."

PopupWindow {
    id: root

    //  networking
    // Networking is a singleton — access directly, do not instantiate.
    // Find the first WifiDevice from Networking.devices.
    property WifiDevice wifiDev: {
        for (const d of Networking.devices.values) {
            if (d.type === DeviceType.Wifi)
                return d;
        }
        return null;
    }

    color: "transparent"
    grabFocus: true
    implicitHeight: menuColumn.implicitHeight + 8
    implicitWidth: 340

    // Enable scanner while popup is visible so the list stays live.
    onVisibleChanged: {
        if (wifiDev)
            wifiDev.scannerEnabled = visible;
    }

    Variables {
        id: v
    }
    anchor {
        edges: Edges.Bottom
        item: networkWidget
        rect.x: 16 - networkWidget.width / 2
        rect.y: 38
    }

    //  visual chrome (unchanged)
    Item {
        id: mask

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            anchors.topMargin: 0
            color: "#fff"
            radius: 8
        }
    }
    RectangularShadow {
        id: outerShadow

        anchors.fill: parent
        blur: 10
        color: v.shadowColor
        radius: dropdown.radius
        spread: -8
        visible: false
    }
    MultiEffect {
        anchors.fill: outerShadow
        maskEnabled: true
        maskInverted: true
        maskSource: mask
        source: outerShadow
    }
    Rectangle {
        id: dropdown

        anchors.fill: parent
        anchors.margins: 8
        anchors.topMargin: 0
        border.color: v.popupBorder
        border.width: 1
        color: v.popupBackground
        radius: 8
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 7
        anchors.topMargin: -1
        border.color: v.outerBorderColor
        border.width: 1
        color: "transparent"
        radius: dropdown.radius
    }

    //  menu contents
    ColumnLayout {
        id: menuColumn

        spacing: 0

        anchors {
            bottomMargin: 4
            left: dropdown.left
            leftMargin: 0
            right: dropdown.right
            rightMargin: 0
            top: dropdown.top
            topMargin: 4
        }
        Rectangle {
            Layout.fillWidth: true
            color: "transparent"
            implicitHeight: 10
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 0
            Layout.rightMargin: 14

            MenuLabel {
                Layout.fillWidth: true
                label: "Wi-Fi"
                labelElement.font.weight: 600
            }
            Rectangle {
                color: Networking.wifiEnabled ? v.accentColor : v.accentMuted
                implicitHeight: 28
                implicitWidth: 48
                radius: 16

                Behavior on color {
                    ColorAnimation {
                        duration: 160
                        easing.type: Easing.InOutQuad
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    color: v.accentForeground
                    implicitHeight: 24
                    implicitWidth: 24
                    radius: 12
                    x: Networking.wifiEnabled ? 22 : 2

                    Behavior on x {
                        NumberAnimation {
                            duration: 160
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            color: "transparent"
            implicitHeight: 3
        }
        MenuDiv {
        }
        MenuLabel {
            label: "Networks"
            labelElement.color: v.textPlaceholder
            labelElement.font.weight: 600
        }

        //  no adapter / scanning placeholder
        Loader {
            Layout.fillWidth: true
            visible: !wifiDev || (wifiDev.networks.count === 0)

            sourceComponent: Item {
                implicitHeight: 36

                Text {
                    anchors.centerIn: parent
                    color: v.textPlaceholder
                    font.pixelSize: 13
                    text: !wifiDev ? "No Wi-Fi adapter found" : wifiDev.scannerEnabled ? "Scanning…" : "No networks"
                }
            }
        }

        //  network list
        // WifiDevice.networks is an ObjectModel; each item is a
        // connect(), disconnect(), forget()
        Repeater {
            model: wifiDev ? wifiDev.networks : null

            delegate: IconItem {
                required property WifiNetwork modelData

                iconName: {
                    const secured = modelData.security !== WifiSecurityType.None;
                    const s = modelData.signalStrength;
                    if (modelData.connected)
                        return "folder-wifi";
                    if (s > 0.75)
                        return "network-wireless-signal-excellent-symbolic";
                    if (s > 0.50)
                        return "network-wireless-signal-good-symbolic";
                    if (s > 0.25)
                        return "network-wireless-signal-weak-symbolic";
                    return "network-wireless-signal-none-symbolic";
                }
                label: modelData.name || "(hidden)"
                // Highlight the currently connected network
                selected: modelData.connected

                onTriggered: {
                    if (modelData.connected) {
                        // Already connected — disconnect on second click
                        modelData.disconnect();
                    } else {
                        // connect() fires; an NM auth agent handles passwords
                        // for unknown secured networks automatically
                        modelData.connect();
                    }
                    root.visible = false;
                }
            }
        }
        MenuDiv {
        }
        MenuItem {
            label: "Wi-Fi Settings…"

            onTriggered: {
                preferences.running = true;
                root.visible = false;
            }
        }
        Item {
            Layout.preferredHeight: 8
        }
    }

    //  processes
    Process {
        id: preferences

        command: ["bash", "-c", "kcmshell6 kcm_networkmanagement"]
        running: false
    }
}
