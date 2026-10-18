import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Bluetooth
import qs.share.menu
import "../.."

PopupWindow {
    id: root

    color: "transparent"
    grabFocus: true
    implicitHeight: menuColumn.implicitHeight + 8
    implicitWidth: 340

    Variables {
        id: v
    }
    anchor {
        edges: Edges.Bottom
        item: bluetoothWidget
        rect.x: 16 - bluetoothWidget.width / 2
        rect.y: 38
    }
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

    // ── menu contents ────────────────────────────────────────────────────────
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
                label: "Bluetooth"
                labelElement.font.weight: 600
            }
            Rectangle {
                color: Bluetooth.defaultAdapter.enabled ? v.accentColor : v.accentMuted
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
                    x: 2

                    Behavior on x {
                        NumberAnimation {
                            duration: 160
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            color: "transparent"
            implicitHeight: 6
        }
        MenuDiv {
        }
        // ── no adapter placeholder ────────────────────────────────────
        Loader {
            Layout.fillWidth: true
            visible: !Bluetooth.defaultAdapter

            sourceComponent: Item {
                implicitHeight: 36

                Text {
                    anchors.centerIn: parent
                    color: v.textPlaceholder
                    font.pixelSize: 13
                    text: "No Bluetooth adapter found"
                }
            }
        }

        // ── paired devices ─────────────────────────────────────────────
        MenuLabel {
            label: "Paired"
            labelElement.color: v.textHeader
            labelElement.font.weight: 600
            visible: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
        }
        Repeater {
            model: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.devices : null

            delegate: IconItem {
                readonly property BluetoothDevice device: modelData
                required property var modelData

                iconName: device.icon || (device.connected ? "network-bluetooth-symbolic" : "bluetooth-symbolic")
                label: device.name || device.deviceName || device.address
                selected: device.connected
                visible: device.paired

                onTriggered: {
                    if (device.connected) {
                        device.disconnect();
                    } else {
                        device.connect();
                    }
                }
            }
        }

        // ── available devices (unpaired, with a real name) ─────────────
        MenuLabel {
            label: "Available"
            labelElement.color: v.textHeader
            labelElement.font.weight: 600
            visible: {
                if (!Bluetooth.defaultAdapter || !Bluetooth.defaultAdapter.enabled)
                    return false;
                for (let i = 0; i < Bluetooth.defaultAdapter.devices.count; i++) {
                    let d = Bluetooth.defaultAdapter.devices.get(i);
                    if (!d.paired && d.deviceName && d.deviceName.length > 0)
                        return true;
                }
                return false;
            }
        }
        Repeater {
            model: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.devices : null

            delegate: IconItem {
                readonly property BluetoothDevice device: modelData
                required property var modelData

                iconName: device.icon || "bluetooth-symbolic"
                label: device.name || device.deviceName
                selected: false

                // Only show unpaired devices that report a proper name
                visible: !device.paired && (device.deviceName && device.deviceName.length > 0)

                onTriggered: {
                    device.connect();
                }
            }
        }
        MenuDiv {
        }
        MenuItem {
            label: "Bluetooth Settings..."

            onTriggered: {
                preferences.running = true;
                root.visible = false;
            }
        }
        Process {
            id: preferences

            command: ["bash", "-c", "kcmshell6 kcm_bluetooth"]
            running: false
        }
        Item {
            Layout.preferredHeight: 8
        }
    }
}
