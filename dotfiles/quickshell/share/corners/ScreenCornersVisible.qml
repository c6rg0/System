import Quickshell
import QtQuick

Item {
    implicitHeight: parent.height
    implicitWidth: parent.width

    anchors {
        fill: parent
    }
    CutoutCorner {
        color: "black"
        cornerHeight: 16
        cornerType: "inverted"
        corners: 4

        anchors {
            right: parent.right
        }
    }
}
