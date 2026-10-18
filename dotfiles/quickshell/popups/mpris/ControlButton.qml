import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property bool active: false
    property string icon: ""
    property real size: 32

    signal activated

    Layout.preferredHeight: size
    Layout.preferredWidth: size
    implicitHeight: size
    implicitWidth: size

    // Hover / press highlight
    Rectangle {
        anchors.centerIn: parent
        color: "transparent"
        implicitHeight: root.size * 0.9
        implicitWidth: root.size * 0.9
        radius: width / 2
    }
    Text {
        anchors.centerIn: parent
        color: "#fff"
        font.pixelSize: root.size * 0.55
        text: root.icon
    }
    MouseArea {
        id: mouseArea

        anchors.fill: parent
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: true

        onClicked: if (root.enabled)
            root.activated()
    }
}
