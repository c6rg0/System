import QtQuick
import ".."

// Segmented pill for picking the capture mode.
//
// Unlike the standalone ControlBar, the highlight follows the tab that is
// actually selected instead of collapsing the active tab out of the row, and
// visible tabs are the ones flagged visible: a hidden tab still holds its width
// here, so the highlighted pill would otherwise slide to the wrong place.
Rectangle {
    id: root

    property bool editActive: false
    property string mode: "region"
    property var modes: []
    readonly property int selectedIndex: Math.max(0, visibleModes.indexOf(root.mode))
    readonly property real tabItemSize: 100
    property bool tempActive: false
    readonly property var visibleModes: modes.filter(m => {
        if (m === "edit")
            return !root.editActive;
        if (m === "temp")
            return !root.tempActive;
        return true;
    })

    signal modeSelected(string mode)

    border.color: v.popupBorder
    border.width: 1
    color: "#303030"
    implicitHeight: 50
    implicitWidth: visibleModes.length * tabItemSize + 8
    radius: height / 2

    Behavior on implicitWidth {
        enabled: root.tabItemSize > 0

        SpringAnimation {
            damping: 0.25
            mass: 1
            spring: 4
        }
    }

    Variables {
        id: v
    }
    Rectangle {
        id: highlight

        color: v.accentColor
        height: parent.height - 8
        radius: height / 2
        width: root.tabItemSize
        x: 4 + root.selectedIndex * root.tabItemSize
        y: 4

        Behavior on x {
            SpringAnimation {
                damping: 0.25
                mass: 1
                spring: 4
            }
        }
    }
    Row {
        anchors.fill: parent
        anchors.margins: 4

        Repeater {
            model: root.visibleModes

            Item {
                id: tabItem

                required property string modelData

                height: root.height - 8
                width: root.tabItemSize

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: root.modeSelected(tabItem.modelData)
                }
                Text {
                    anchors.centerIn: parent
                    color: root.mode === tabItem.modelData ? v.accentForeground : v.textSecondary
                    font.pixelSize: 15
                    font.weight: root.mode === tabItem.modelData ? Font.Bold : Font.Medium
                    text: {
                        const icons = {
                            "region": "󰒉",
                            "temp": "󰅇",
                            "edit": "󰏫"
                        };
                        const labels = {
                            "region": "Region",
                            "temp": "Temp",
                            "edit": "Edit"
                        };
                        return (icons[tabItem.modelData] || "") + "  " + (labels[tabItem.modelData] || tabItem.modelData);
                    }
                }
            }
        }
    }
}
