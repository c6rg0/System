import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.popups.clock
import ".."

Item {
    id: root

    Layout.fillHeight: true
    Layout.leftMargin: 6
    Layout.rightMargin: 3
    implicitWidth: clockLabel.implicitWidth + 24  // 6px left + 18px right

    Variables {
        id: v
    }
    SystemClock {
        id: sysClock

        precision: SystemClock.Minutes
    }
    Rectangle {
        anchors.fill: parent
        color: clockPopup.visible ? v.widgetHighlight : "transparent"
        radius: 6
    }
    Text {
        id: clockLabel

        color: v.textColor
        font.family: "SF Pro"
        font.pixelSize: 20
        renderType: Text.NativeRendering
        text: Qt.formatDateTime(sysClock.date, "ddd MMM d   hh:mm AP")

        anchors {
            left: parent.left
            leftMargin: 6
            verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            clockPopup.visible = !clockPopup.visible;
            clockPopup.updatesEnabled = clockPopup.visible;
        }
    }
    ClockPopup {
        id: clockPopup

        visible: false
    }
}
