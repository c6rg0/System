import QtQuick
import QtQuick.Layouts
import "../.."

Rectangle {
    Layout.bottomMargin: 4
    Layout.fillWidth: true
    Layout.leftMargin: 18
    Layout.rightMargin: 18
    Layout.topMargin: 4
    color: v.menuDividerColor
    implicitHeight: 1

    Variables {
        id: v
    }
}
