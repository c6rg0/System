import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.share.app
import ".."

Item {
    id: root

    readonly property string displayName: HyprlandExt.applicationName != "" ? HyprlandExt.applicationName : "Finder"

    Layout.fillHeight: true
    Layout.leftMargin: 0
    Layout.rightMargin: 4
    implicitWidth: titleLabel.implicitWidth + 24  // 12px each side

    Variables {
        id: v
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
    }
    Text {
        id: titleLabel

        anchors.centerIn: parent
        color: v.textColor
        font.capitalization: Font.Capitalize
        font.family: "SF Pro"
        font.pixelSize: 22
        font.weight: 600
        renderType: Text.NativeRendering
        text: root.displayName
    }
    MouseArea {
        anchors.fill: parent
    }
}
