import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Widgets
import ".."
import qs.popups.battery

Item {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool charging: {
        let s = battery.state;
        return s === UPowerDeviceState.Charging || s === UPowerDeviceState.FullyCharged || s === UPowerDeviceState.PendingCharge;
    }
    readonly property string iconName: {
        let pct = battery.ready ? Math.round(battery.percentage * 10) * 10 : 0;
        pct = Math.max(0, Math.min(100, pct));

        if (pct < 10)
            return "battery-level-10" + (charging ? "-charging" : "");
        if (pct < 20)
            return "battery-level-20" + (charging ? "-charging" : "");
        if (pct < 30)
            return "battery-level-30" + (charging ? "-charging" : "");
        if (pct < 50)
            return "battery-level-50" + (charging ? "-charging" : "");
        if (pct < 70)
            return "battery-level-70" + (charging ? "-charging" : "");
        return "battery-level-90" + (charging ? "-charging" : "");
    }

    Layout.fillHeight: true
    implicitWidth: batteryIcon.implicitWidth + 32  // 12px left + 20px right pad

    Variables {
        id: v
    }
    Rectangle {
        id: batteryWidget

        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 3
        color: batteryPopup.visible ? v.widgetHighlight : "transparent"
        radius: 6
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            batteryPopup.visible = !batteryPopup.visible;
        }
    }
    IconImage {
        id: batteryIcon
        anchors.centerIn: parent
        implicitSize: 32
        source: Qt.resolvedUrl("../share/icons/" + root.iconName + "-symbolic.svg")
    }
    BatteryPopup {
        id: batteryPopup

        visible: false
    }
}
