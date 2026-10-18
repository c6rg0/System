import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.popups.logo
import ".."

Item {
    id: root

    property bool hovered: false

    Layout.fillHeight: true
    Layout.leftMargin: 12
    implicitWidth: logoLabel.implicitWidth + 26  // 12px left pad + 14px right pad

    Variables {
        id: v
    }
    Rectangle {
        anchors.fill: parent
        color: logoMenu.visible ? v.accentColor : "transparent"
    }
    Text {
        id: logoLabel

        anchors.centerIn: parent
        color: logoMenu.visible ? v.accentForeground : v.textColor
        font.family: "FiraCode Nerd Font"
        font.pixelSize: 30
        text: ""
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: logoMenu.visible = !logoMenu.visible
        onEntered: root.hovered = true
        onExited: root.hovered = false
    }
    LogoMenu {
        id: logoMenu

        visible: false
    }
}
