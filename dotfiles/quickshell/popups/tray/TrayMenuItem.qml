import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.share.menu
import "../.."

Rectangle {
    id: root

    property PopupWindow dropdown
    property QsMenuHandle menuHandle

    Layout.bottomMargin: menuHandle.isSeparator ? 4 : 0
    Layout.fillWidth: true
    Layout.leftMargin: 4
    Layout.rightMargin: 4
    Layout.topMargin: menuHandle.isSeparator ? 4 : 0
    color: "transparent"
    implicitHeight: menuHandle.isSeparator ? 1 : 32

    Variables {
        id: v
    }
    Rectangle {
        anchors.fill: parent
        color: "#33000000"
        visible: menuHandle.isSeparator
    }
    Rectangle {
        id: item

        property bool hovered: false

        anchors.fill: parent
        color: hovered ? v.accentColor : "transparent"
        radius: 4
        visible: !menuHandle.isSeparator

        RowLayout {
            spacing: 10

            anchors {
                fill: parent
                leftMargin: 14
                rightMargin: 14
            }
            Image {
                source: menuHandle.icon
                sourceSize.height: 18
                sourceSize.width: 18
                visible: menuHandle.icon !== ""
            }
            Text {
                id: labelText

                Layout.fillWidth: true
                color: item.hovered ? v.accentForeground : v.textColor
                elide: Text.ElideRight
                font.family: "SF Pro"
                font.pixelSize: 18
                text: menuHandle.text
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle {
                border.color: "#77a0a2"
                border.width: 1
                color: "#10000000"
                implicitHeight: 16
                implicitWidth: 16
                radius: 8
                visible: menuHandle.buttonType !== 0

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3
                    color: v.accentColor
                    radius: 8
                    visible: menuHandle.checkState != 0
                }
            }
            Text {
                color: item.hovered ? v.accentForeground : v.textSecondary
                text: ""
                visible: menuHandle.hasChildren
            }
        }
        // Loader {
        //     id: childMenuLoader
        //     active: false
        // }
        // QsMenuOpener {
        //     id: menuOpener
        //     menu: menuHandle
        // }
        //TrayPopup {
        //id: childMenu
        //anchorPoint: mouseArea
        //}
        //childMenu.menuHandle: menuHandle
        //QsMenuOpener {
        //    id: childOpener
        //    menu: menuHandle
        //}
        //TrayPopup {
        //    id: child
        //    anchorPoint: item
        //    menuHandle: childOpener.chilren
        // }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: {
                menuHandle.triggered();
                dropdown.visible = menuHandle.hasChildren || (menuHandle.buttonType !== 0);
                //childMenu.visible = menuHandle.hasChildren;
            }
            onEntered: item.hovered = true
            onExited: item.hovered = false
        }
    }
}
