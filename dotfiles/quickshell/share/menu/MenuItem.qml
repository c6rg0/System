// MenuItem.qml
import QtQuick
import QtQuick.Layouts
import "../.."

Rectangle {
    id: item

    property bool hasSubmenu: false
    property bool hovered: false
    property string label: ""
    property alias labelElement: labelText
    property alias mouseArea: mouseArea
    property string shortcut: ""

    signal triggered

    Layout.fillWidth: true
    Layout.leftMargin: 4
    Layout.rightMargin: 4
    color: hovered ? v.accentColor : "transparent"
    implicitHeight: 32
    radius: 4

    Variables {
        id: v
    }
    RowLayout {
        spacing: 0

        anchors {
            fill: parent
            leftMargin: 14
            rightMargin: 14
        }
        Text {
            id: labelText

            Layout.fillWidth: true
            color: item.hovered ? v.accentForeground : v.textColor
            font.family: "SF Pro"
            font.pixelSize: 18
            text: item.label
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            color: item.hovered ? v.accentForeground : v.textColor
            font.pixelSize: 16
            text: "›"
            visible: item.hasSubmenu
        }
        Text {
            color: item.hovered ? "#ddeeff" : v.textSecondary
            font.family: "SF Pro"
            font.pixelSize: 16
            text: item.shortcut
            visible: item.shortcut !== ""
        }
    }
    MouseArea {
        id: mouseArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: item.triggered()
        onEntered: item.hovered = true
        onExited: item.hovered = false
    }
}
