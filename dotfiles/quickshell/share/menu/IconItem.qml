// MenuItem.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../.."

Rectangle {
    id: item

    property bool hovered: false
    property alias iconName: iconButton.icon.name
    property string label: ""
    property alias labelElement: labelText
    property alias mouseArea: mouseArea
    property bool selected: false

    signal triggered

    Layout.fillWidth: true
    Layout.leftMargin: 4
    Layout.rightMargin: 4
    color: hovered ? v.widgetHighlight : "transparent"
    implicitHeight: 40
    radius: 4

    Variables {
        id: v
    }
    RowLayout {
        spacing: 10

        anchors {
            fill: parent
            leftMargin: 14
            rightMargin: 14
        }
        Rectangle {
            color: selected ? v.accentColor : "#20A0A0A0"
            implicitHeight: 32
            implicitWidth: 32
            radius: 16

            Button {
                id: iconButton

                flat: true
                icon.color: selected ? v.accentForeground : "#888"
                icon.name: "headphone"
                implicitHeight: 32
                implicitWidth: 32
            }
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
