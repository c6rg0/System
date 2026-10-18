import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../.."

PanelWindow {
    id: root

    //  Calendar data model
    property var calendarModel: {
        var days = [];
        var firstDay = new Date(viewYear, viewMonth, 1);
        var startOffset = firstDay.getDay();  // 0 = Sunday
        var daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();

        // Days from previous month
        var prevMonthLastDay = new Date(viewYear, viewMonth, 0).getDate();
        var prevMonth = viewMonth === 0 ? 11 : viewMonth - 1;
        var prevYear = viewMonth === 0 ? viewYear - 1 : viewYear;
        for (var i = startOffset - 1; i >= 0; i--) {
            days.push({
                dayNumber: prevMonthLastDay - i,
                isCurrentMonth: false,
                isToday: false,
                isWeekend: false,
                monthIndex: prevMonth,
                yearNumber: prevYear
            });
        }

        // Current month days
        var now = new Date();
        var todayDate = now.getDate();
        var todayMonth = now.getMonth();
        var todayYear = now.getFullYear();
        for (var d = 1; d <= daysInMonth; d++) {
            var wday = new Date(viewYear, viewMonth, d).getDay();
            var isToday = (d === todayDate && viewMonth === todayMonth && viewYear === todayYear);
            days.push({
                dayNumber: d,
                isCurrentMonth: true,
                isToday: isToday,
                isWeekend: (wday === 0 || wday === 6),
                monthIndex: viewMonth,
                yearNumber: viewYear
            });
        }

        // Days from next month to fill the last row
        var remaining = 7 - (days.length % 7);
        if (remaining < 7) {
            var nextMonth = viewMonth === 11 ? 0 : viewMonth + 1;
            var nextYear = viewMonth === 11 ? viewYear + 1 : viewYear;
            for (var n = 1; n <= remaining; n++) {
                days.push({
                    dayNumber: n,
                    isCurrentMonth: false,
                    isToday: false,
                    isWeekend: false,
                    monthIndex: nextMonth,
                    yearNumber: nextYear
                });
            }
        }

        return days;
    }
    readonly property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    //  Date state
    property date today: new Date()
    property int viewMonth: today.getMonth()  // 0‑based

    property int viewYear: today.getFullYear()
    readonly property var weekdayHeaders: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

    WlrLayershell.namespace: "qs:popup"
    color: "transparent"
    exclusionMode: "Ignore"
    implicitHeight: outerLayout.implicitHeight
    implicitWidth: 340
    margins.right: -6
    margins.top: 32
    updatesEnabled: false

    Variables {
        id: v
    }
    anchors {
        right: true
        top: true
    }

    //  Tick timer
    Timer {
        interval: 1000
        repeat: true
        running: root.visible

        onTriggered: root.today = new Date()
    }
    ColumnLayout {
        id: outerLayout

        spacing: -16

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        Rectangle {
            id: card

            Layout.fillWidth: true
            color: "transparent"
            implicitHeight: contentColumn.implicitHeight + 64
            radius: 16

            Item {
                id: mask

                anchors.fill: card
                layer.enabled: true
                visible: false

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 16
                    color: "#fff"
                    radius: card.radius
                }
            }
            RectangularShadow {
                id: outerShadow

                anchors.fill: card
                blur: 16
                color: v.shadowColor
                radius: card.radius
                spread: -16
                visible: false
            }
            MultiEffect {
                anchors.fill: outerShadow
                maskEnabled: true
                maskInverted: true
                maskSource: mask
                source: outerShadow
            }
            Rectangle {
                id: borderRect

                anchors.fill: parent
                anchors.margins: 16
                border.color: v.popupBorder
                border.width: 1
                color: v.popupBackground
                radius: parent.radius
            }
            Rectangle {
                anchors.fill: parent
                anchors.margins: 15
                border.color: v.outerBorderColor
                border.width: 1
                color: "transparent"
                radius: parent.radius
            }
            ColumnLayout {
                id: contentColumn

                spacing: 0

                anchors {
                    left: parent.left
                    margins: 32
                    right: parent.right
                    top: parent.top
                }

                //  Time
                Item {
                    Layout.bottomMargin: 4
                    Layout.fillWidth: true
                    Layout.preferredHeight: timeColumn.implicitHeight
                    Layout.topMargin: 16

                    ColumnLayout {
                        id: timeColumn

                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 0

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            color: "#fff"
                            font.family: "SF Pro"
                            font.pixelSize: 48
                            text: root.today.toLocaleTimeString(Qt.locale(), "hh:mm")
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            color: "#fff"
                            font.family: "SF Pro"
                            font.pixelSize: 14
                            text: root.today.toLocaleTimeString(Qt.locale(), "AP")
                        }
                    }
                }

                //  Full date
                Text {
                    Layout.bottomMargin: 14
                    Layout.fillWidth: true
                    Layout.topMargin: 0
                    color: "#aaa"
                    font.family: "SF Pro"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    text: root.today.toLocaleDateString(Qt.locale(), "dddd, MMMM d, yyyy")
                }

                //  Separator
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#22000000"
                }

                //  Month navigation
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.topMargin: 8

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 0
                        width: parent.width - 8

                        // Previous month
                        Text {
                            Layout.preferredWidth: 28
                            color: "#888"
                            font.family: "SF Pro"
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            text: "◀"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    if (root.viewMonth === 0) {
                                        root.viewMonth = 11;
                                        root.viewYear--;
                                    } else {
                                        root.viewMonth--;
                                    }
                                }
                            }
                        }

                        // Month + Year label
                        Text {
                            Layout.fillWidth: true
                            color: "#fff"
                            font.family: "SF Pro"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            text: root.monthNames[root.viewMonth] + " " + root.viewYear
                        }

                        // Go to today
                        Text {
                            Layout.preferredWidth: 28
                            color: "#888"
                            font.family: "SF Pro"
                            font.pixelSize: 8
                            horizontalAlignment: Text.AlignHCenter
                            text: "●"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    root.viewMonth = root.today.getMonth();
                                    root.viewYear = root.today.getFullYear();
                                }
                            }
                        }

                        // Next month
                        Text {
                            Layout.preferredWidth: 28
                            color: "#888"
                            font.family: "SF Pro"
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            text: "▶"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    if (root.viewMonth === 11) {
                                        root.viewMonth = 0;
                                        root.viewYear++;
                                    } else {
                                        root.viewMonth++;
                                    }
                                }
                            }
                        }
                    }
                }

                //  Weekday headers
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    spacing: 0

                    Repeater {
                        model: root.weekdayHeaders

                        delegate: Text {
                            Layout.fillWidth: true
                            color: "#999"
                            font.family: "SF Pro"
                            font.pixelSize: 10
                            font.weight: Font.Bold
                            horizontalAlignment: Text.AlignHCenter
                            text: modelData
                        }
                    }
                }

                //  Calendar grid
                GridLayout {
                    id: calendarGrid

                    Layout.bottomMargin: 16
                    Layout.fillWidth: true
                    columnSpacing: 0
                    columns: 7
                    rowSpacing: 0

                    Repeater {
                        model: root.calendarModel

                        delegate: Rectangle {
                            readonly property var d: modelData

                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            color: "transparent"

                            Rectangle {
                                anchors.centerIn: parent
                                color: {
                                    if (d.isToday)
                                        return "#007aff";                     // macOS blue
                                    if (d.isCurrentMonth && d.isWeekend)
                                        return "#20000000";
                                    return "transparent";
                                }
                                height: 28
                                radius: 14
                                width: 28

                                Text {
                                    anchors.centerIn: parent
                                    color: {
                                        if (d.isToday)
                                            return "#fff";
                                        if (!d.isCurrentMonth)
                                            return "#666";
                                        return "#fff";
                                    }
                                    font.family: "SF Pro"
                                    font.pixelSize: 12
                                    font.weight: d.isToday ? Font.DemiBold : Font.Normal
                                    text: d.dayNumber
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    if (d.isCurrentMonth) {
                                        root.viewMonth = d.monthIndex;
                                        root.viewYear = d.yearNumber;
                                    }
                                }
                            }
                        }
                    }
                }
            } // ColumnLayout
        } // card

        Rectangle {
            id: card2

            Layout.fillWidth: true
            color: "transparent"
            implicitHeight: contentColumn2.implicitHeight + 64
            radius: 16

            Item {
                id: mask2

                anchors.fill: card2
                layer.enabled: true
                visible: false

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 16
                    color: "#fff"
                    radius: card2.radius
                }
            }
            RectangularShadow {
                id: outerShadow2

                anchors.fill: card2
                blur: 16
                color: v.shadowColor
                radius: card2.radius
                spread: -16
                visible: false
            }
            MultiEffect {
                anchors.fill: outerShadow2
                maskEnabled: true
                maskInverted: true
                maskSource: mask2
                source: outerShadow2
            }
            Rectangle {
                id: borderRect2

                anchors.fill: card2
                anchors.margins: 16
                border.color: v.popupBorder
                border.width: 1
                color: v.popupBackground
                radius: card2.radius
            }
            Rectangle {
                anchors.fill: card2
                anchors.margins: 15
                border.color: v.outerBorderColor
                border.width: 1
                color: "transparent"
                radius: card2.radius
            }
            ColumnLayout {
                id: contentColumn2

                spacing: 0

                anchors {
                    left: card2.left
                    margins: 32
                    right: card2.right
                    top: card2.top
                }

                //  Heading
                Text {
                    Layout.bottomMargin: 8
                    Layout.fillWidth: true
                    Layout.topMargin: 16
                    color: "#555"
                    font.family: "SF Pro"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    text: "Notifications"
                }

                //  Empty state
                Text {
                    Layout.bottomMargin: 16
                    Layout.fillWidth: true
                    color: "#aaa"
                    font.family: "SF Pro"
                    font.pixelSize: 11
                    font.weight: Font.Light
                    horizontalAlignment: Text.AlignHCenter
                    text: "No notifications"
                    //visible: notifRepeater.count === 0
                    visible: true
                }

                //  Notification list
                ColumnLayout {
                    id: notifList

                    Layout.bottomMargin: 12
                    Layout.fillWidth: true
                    spacing: 6
                    visible: false
                }
            }
        }
    }
}
