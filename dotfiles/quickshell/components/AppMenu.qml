import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    Layout.fillHeight: true
    implicitWidth: menuLabel.implicitWidth + 12

    Variables {
        id: v
    }
    Text {
        id: menuLabel

        color: v.textColor
        font.family: "SF Pro"
        font.pixelSize: 21
        renderType: Text.NativeRendering
        text: "File     Edit     View     Go     Window     Help"

        anchors {
            left: parent.left
            leftMargin: 14
            verticalCenter: parent.verticalCenter
        }
    }
}
