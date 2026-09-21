import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import Quickshell.Widgets
import ".."
import qs.popups.network

Item {
    Variables { id: v }
    id: root

    Layout.fillHeight: true
    implicitWidth: 44
    Rectangle {
        id: networkWidget
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 3
        radius: 6
        color: networkPopup.visible ? v.widgetHighlight : "transparent"
    }

    readonly property var wifiDevice: {
        let devs = Networking.devices.values;
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].connected && devs[i].type === DeviceType.Wifi)
                return devs[i];
        }
        return null;
    }

    readonly property var activeWifiNetwork: {
        if (!wifiDevice)
            return null;
        let nets = wifiDevice.networks.values;
        for (let i = 0; i < nets.length; i++) {
            if (nets[i].connected)
                return nets[i];
        }
        return null;
    }

    readonly property bool ethernetConnected: {
        let devs = Networking.devices.values;
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].connected && devs[i].type !== DeviceType.Wifi)
                return true;
        }
        return false;
    }

    readonly property string iconName: {
        if (activeWifiNetwork) {
            let s = activeWifiNetwork.signalStrength;
            if (s > 0.90)
                return "nm-signal-100";
            if (s > 0.75)
                return "nm-signal-75";
            if (s > 0.50)
                return "nm-signal-50";
            if (s > 0.25)
                return "nm-signal-25";
            return "nm-signal-0";
        }
        if (ethernetConnected)
            return "network-wired";
        return "nm-no-connection";
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            networkPopup.visible = !networkPopup.visible;
e       }
    }

    IconImage {
        anchors.centerIn: parent
        implicitSize: 26
        source: root.iconName != null ? Qt.resolvedUrl("../share/icons/" + root.iconName + "-symbolic.svg") : Qt.resolvedUrl("../share/icons/nm-no-connection-symbolic.svg")
    }
    NetworkPopup {
        id: networkPopup
        visible: false
    }
}
