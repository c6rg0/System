// MenuItem.qml
import QtQuick
import QtQuick.Layouts
import "../.."

Rectangle {
    id: item

    property bool hovered: false
    property string label: ""
    property alias labelElement: labelText
    property string secondary: ""
    property alias secondaryElement: labelSecondary

    Layout.fillWidth: true
    Layout.leftMargin: 4
    Layout.rightMargin: 4
    color: "transparent"
    implicitHeight: 32

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
            color: v.textColor
            font.family: "SF Pro"
            font.pixelSize: 18
            text: item.label
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: labelSecondary

            color: "#808080"
            font.family: "SF Pro"
            font.pixelSize: 16
            text: item.secondary
            visible: item.secondary !== ""
        }
    }
}
