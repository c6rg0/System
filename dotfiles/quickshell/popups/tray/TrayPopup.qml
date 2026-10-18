import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../.."

PopupWindow {
    id: root

    property MouseArea anchorPoint
    property QsMenuHandle menuHandle

    color: "transparent"
    grabFocus: true
    implicitHeight: menuColumn.implicitHeight + 16
    implicitWidth: 240

    Variables {
        id: v
    }
    QsMenuOpener {
        id: opener

        menu: menuHandle
    }
    anchor {
        item: anchorPoint
        rect.x: -12
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
        Repeater {
            model: opener.children

            delegate: TrayMenuItem {
                required property QsMenuHandle modelData

                dropdown: root
                menuHandle: modelData
            }
        }
    }
}
