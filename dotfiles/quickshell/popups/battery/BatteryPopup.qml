import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.UPower

import qs.share.menu
import "../.."

PopupWindow {
    id: root

    readonly property var battery: UPower.displayDevice

    color: "transparent"
    grabFocus: true
    implicitHeight: menuColumn.implicitHeight + 8
    implicitWidth: 280

    Variables {
        id: v
    }
    anchor {
        edges: Edges.Bottom
        item: batteryWidget
        rect.x: 18 - batteryWidget.width / 2
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
        MenuLabel {
            label: "Battery"
            labelElement.font.weight: 600
            secondary: String(Math.round(battery.percentage * 100)) + "%"
            secondaryElement.color: "#eee"
        }
        MenuLabel {
            label: "Power Source:  " + (battery.state != 2 ? "Power Adapter" : "Battery")
            labelElement.color: "#666"
        }
        MenuLabel {
            label: battery.state != 2 ? (battery.changeRate > 2 ? "Charging (" + Math.floor(battery.changeRate * 10) / 10 + " W)" : "Fully Charged") : String(Math.round(battery.timeToEmpty / 60)) + " min Remaining (" + String(Math.round(battery.changeRate * 10) / 10) + " W)"
            labelElement.color: "#666"
        }
        MenuDiv {
        }
        MenuLabel {
            label: "Energy Mode"
            labelElement.color: v.textPlaceholder
            labelElement.font.weight: 600
        }
        IconItem {
            iconName: "battery-profile-performance"
            label: "High Power"
            selected: (PowerProfiles.profile == 2)

            onTriggered: PowerProfiles.profile = 2
        }
        IconItem {
            iconName: "battery-040"
            label: "Balanced"
            selected: (PowerProfiles.profile == 1)

            onTriggered: PowerProfiles.profile = 1
        }
        IconItem {
            iconName: "battery-profile-powersave"
            label: "Low Power"
            selected: (PowerProfiles.profile == 0)

            onTriggered: PowerProfiles.profile = 0
        }
        MenuDiv {
        }
        MenuItem {
            label: "Battery Preferences..."

            onTriggered: {
                preferences.running = true;
                root.visible = false;
            }
        }
        Process {
            id: preferences

            command: ["bash", "-c", "kcmshell6 kcm_mobile_power"]
            running: false
        }

        // bottom padding
        Item {
            Layout.preferredHeight: 8
        }
    }
}
