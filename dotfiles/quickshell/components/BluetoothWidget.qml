import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import Quickshell.Widgets
import ".."
import qs.popups.bluetooth

Item {
    id: root

    readonly property string iconName: {
        if (!Bluetooth.defaultAdapter)
            return "bluetooth-disabled";
        return "bluetooth-active";
    }

    Layout.fillHeight: true
    implicitWidth: 20 + 32  // icon size + 12px left + 20px right pad

    Variables {
        id: v
    }
    Rectangle {
        id: bluetoothWidget

        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 3
        color: bluetoothPopup.visible ? v.widgetHighlight : "transparent"
        radius: 6
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            bluetoothPopup.visible = !bluetoothPopup.visible;
        }
    }
    IconImage {
        anchors.centerIn: parent
        implicitSize: 28
        source: Qt.resolvedUrl("../share/icons/" + root.iconName + "-symbolic.svg")
    }
    BluetoothPopup {
        id: bluetoothPopup

        visible: false
    }
}
