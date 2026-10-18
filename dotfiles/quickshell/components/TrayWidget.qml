import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell
import ".."
import qs.popups.tray

Item {
    id: rootWidget

    Layout.fillHeight: true
    implicitWidth: trayRow.implicitWidth + 12

    Variables {
        id: v
    }
    Row {
        id: trayRow

        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: root

                required property var modelData

                implicitHeight: 40
                implicitWidth: 32

                TrayPopup {
                    id: trayPopup

                    anchorPoint: trayIconItem
                    menuHandle: modelData.menu
                }
                Rectangle {
                    anchors.fill: parent
                    color: trayPopup.visible ? v.widgetHighlight : "transparent"
                    radius: 6

                    Image {
                        anchors.bottomMargin: 10
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.rightMargin: 6
                        anchors.topMargin: 10
                        asynchronous: true
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        source: modelData.icon
                        sourceSize.height: height
                        sourceSize.width: width
                    }
                    MouseArea {
                        id: trayIconItem

                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onPressed: mouse => {
                            if (mouse.button == Qt.RightButton) {
                                modelData.activate();
                            } else if (mouse.button == Qt.LeftButton) {
                                trayPopup.visible = !trayPopup.visible;
                            }
                        }
                    }
                }
            }
        }
    }
}
