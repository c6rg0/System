import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import qs.share.menu
import "../.."

PopupWindow {
    id: root

    function exec(cmd) {
        shellProc.command = ["bash", "-c", cmd];
        shellProc.running = true;
        root.visible = false;
    }

    color: "transparent"
    grabFocus: true
    implicitHeight: menuColumn.implicitHeight + 8
    implicitWidth: 280

    Variables {
        id: v
    }
    anchor {
        edges: Edges.Bottom
        item: parent
        rect.x: 0
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
    Process {
        id: shellProc

        running: false
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
        MenuItem {
            label: "About This Device"

            onTriggered: {
                root.visible = false;
                aboutMac.show();
            }
        }
        MenuSep {
        }
        MenuItem {
            label: "System Preferences..."

            onTriggered: root.exec("systemsettings")
        }
        MenuItem {
            label: "App Store…"

            onTriggered: root.exec("plasma-discover")
        }
        MenuSep {
        }
        MenuItem {
            hasSubmenu: true
            label: "Recents"

            onTriggered: root.exec("notify-send 'Recents' 'Submenu coming soon'")
        }
        MenuSep {
        }

        //  Force Quit
        MenuItem {
            label: "Force Quit…"
            shortcut: "⌃Q"

            onTriggered: root.exec("hyprctl dispatch 'hl.dsp.window.close()'")
        }
        MenuSep {
        }
        MenuItem {
            label: "Sleep"

            onTriggered: root.exec("systemctl suspend")
        }
        MenuItem {
            label: "Restart…"

            onTriggered: root.exec("systemctl reboot")
        }
        MenuItem {
            label: "Shut Down…"

            onTriggered: root.exec("systemctl poweroff")
        }
        MenuSep {
        }
        MenuItem {
            label: "Lock Screen"
            shortcut: "⌃K"

            onTriggered: root.exec("hyprlock")
        }
        MenuItem {
            label: "Log Out Current User..."
            shortcut: "⌃L"

            onTriggered: root.exec("hyprctl dispatch 'hl.dsp.exit()'")
        }

        // bottom padding
        Item {
            Layout.preferredHeight: 8
        }
    }
    AboutMac {
        id: aboutMac
    }
}
