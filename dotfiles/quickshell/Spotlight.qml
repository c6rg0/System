import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Scope {
    id: root

    /* Whether spotlight is open (shared across all screen variants) */
    property bool open: false

    /*
     * Global shortcut,
     * Bind in hyprland.conf:
     * bind = SUPER, Space, global, quickshell:Spotlight
     */

    GlobalShortcut {
        description: "Toggle Spotlight search"
        name: "Spotlight"

        onPressed: {
            root.open = !root.open;
        }
    }
    Variants {
        id: variants

        model: Quickshell.screens

        PanelWindow {
            id: panelWindow

            required property var modelData

            function applyFilter() {
                filteredModel.values = filteredModel.filter(searchInput.text);
            }
            function forceSearchFocus() {
                searchInput.forceActiveFocus();
            }
            function isFocusedScreen() {
                var fm = Hyprland.focusedMonitor;
                if (!fm)
                    return false;
                var sm = Hyprland.monitorFor(modelData);
                return sm && sm.name === fm.name;
            }
            function launchCurrent() {
                var idx = resultsList.currentIndex;
                if (idx >= 0 && idx < filteredModel.values.length) {
                    filteredModel.values[idx].execute();
                    root.open = false;
                }
            }

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs:spotlight"
            color: "transparent"
            screen: modelData

            // Only visible when spotlight is open AND this is the focused monitor
            visible: root.open && isFocusedScreen()

            //  Reset state when opened
            onVisibleChanged: {
                if (visible) {
                    searchInput.text = "";
                    searchInput.forceActiveFocus();
                    resultsList.currentIndex = 0;
                }
            }

            anchors {
                bottom: true
                left: true
                right: true
                top: true
            }
            Variables {
                id: v
            }

            //  Focus grab for click-outside-to-dismiss
            HyprlandFocusGrab {
                id: focusGrab

                active: panelWindow.visible
                windows: [panelWindow]

                onCleared: {
                    root.open = false;
                }
            }

            //  Dimming background
            Rectangle {
                anchors.fill: parent
                color: 'transparent'

                TapHandler {
                    onTapped: root.open = false
                }
            }

            /* Search card (transparent container for shadow) */
            Rectangle {
                id: card

                property real contentHeight: Math.min(cardLayout.implicitHeight + 16, parent.height - 160)
                property real contentWidth: Math.min(640, parent.width - 80)

                color: "transparent"
                height: contentHeight + 24
                radius: 16
                width: contentWidth + 24

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height * 0.35
                }

                /* Shadow mask */
                Item {
                    id: mask

                    anchors.fill: card
                    layer.enabled: true
                    visible: false

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 12
                        color: "#fff"
                        radius: card.radius
                    }
                }

                /* Shadow */
                RectangularShadow {
                    id: outerShadow

                    anchors.fill: card
                    blur: 12
                    color: v.shadowColor
                    radius: card.radius
                    spread: -12
                    visible: false
                }
                MultiEffect {
                    anchors.fill: outerShadow
                    maskEnabled: true
                    maskInverted: true
                    maskSource: mask
                    source: outerShadow
                }

                /* Visible card background */
                Rectangle {
                    id: cardBg

                    anchors.fill: parent
                    anchors.margins: 12
                    border.color: v.popupBorder
                    border.width: 1
                    color: v.popupBackground
                    radius: card.radius
                }
                Rectangle {
                    id: cardOuterBorder

                    anchors.fill: parent
                    anchors.margins: 11
                    border.color: v.outerBorderColor
                    border.width: 1
                    color: 'transparent'
                    radius: card.radius
                }

                /* Card content */
                ColumnLayout {
                    id: cardLayout

                    spacing: 6

                    anchors {
                        fill: cardBg
                        margins: 10
                    }

                    /* Search bar */
                    Rectangle {
                        id: searchBar

                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        color: Qt.rgba(1, 1, 1, 0.06)
                        radius: 10

                        RowLayout {
                            spacing: 10

                            anchors {
                                fill: parent
                                leftMargin: 12
                                rightMargin: 12
                            }

                            // Magnifying glass icon
                            //Text {
                            //    text: "\uD83D\uDD0D"  // 🔍
                            //    font.pixelSize: 16
                            //    Layout.alignment: Qt.AlignVCenter
                            //}

                            TextInput {
                                id: searchInput

                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                activeFocusOnPress: true
                                color: v.textColor
                                font.pixelSize: 16
                                verticalAlignment: TextInput.AlignVCenter

                                Keys.onPressed: event => {
                                    if (event.key === Qt.Key_Escape) {
                                        root.open = false;
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                        launchCurrent();
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Down) {
                                        if (resultsList.count > 0) {
                                            resultsList.incrementCurrentIndex();
                                        }
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Up) {
                                        if (resultsList.currentIndex > 0) {
                                            resultsList.decrementCurrentIndex();
                                        }
                                        event.accepted = true;
                                    }
                                }
                                onTextChanged: {
                                    applyFilter();
                                    resultsList.currentIndex = 0;
                                }

                                Text {
                                    anchors.fill: parent
                                    color: v.textPlaceholder
                                    font: searchInput.font
                                    text: "Search applications…"
                                    verticalAlignment: Text.AlignVCenter
                                    visible: !searchInput.text && !searchInput.activeFocus
                                }
                            }
                        }
                    }

                    /* Results list */
                    ListView {
                        id: resultsList

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.min(count * 44, 396)
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true
                        keyNavigationEnabled: false
                        model: filteredModel
                        spacing: 2

                        delegate: ItemDelegate {
                            id: delegateItem

                            required property int index
                            required property var modelData

                            height: 44
                            highlighted: index === resultsList.currentIndex
                            width: resultsList.width

                            background: Rectangle {
                                color: delegateItem.highlighted ? v.widgetHighlight : "transparent"
                                radius: 6
                            }
                            contentItem: RowLayout {
                                spacing: 10

                                Image {
                                    Layout.preferredHeight: 28
                                    Layout.preferredWidth: 28
                                    asynchronous: true
                                    fillMode: Image.PreserveAspectFit
                                    source: {
                                        var path = Quickshell.iconPath(modelData.icon, true);
                                        return path ? path : Quickshell.iconPath("application-x-executable");
                                    }
                                    sourceSize.height: 28
                                    sourceSize.width: 28
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1

                                    Text {
                                        Layout.fillWidth: true
                                        color: v.textColor
                                        elide: Text.ElideRight
                                        font.pixelSize: 14
                                        maximumLineCount: 1
                                        text: modelData.name
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        color: v.textSecondary
                                        elide: Text.ElideRight
                                        font.pixelSize: 11
                                        maximumLineCount: 1
                                        text: modelData.genericName || ""
                                        visible: text !== ""
                                    }
                                }
                            }

                            onClicked: {
                                modelData.execute();
                                root.open = false;
                            }
                        }
                    }
                }
            }

            /* Filtered model */
            ScriptModel {
                id: filteredModel

                function filter(text) {
                    if (!text || text.trim() === "") {
                        return [...DesktopEntries.applications.values].sort((a, b) => a.name.toLowerCase().localeCompare(b.name.toLowerCase()));
                    }

                    const lower = text.toLowerCase();
                    return DesktopEntries.applications.values.filter(entry => {
                        return entry.name.toLowerCase().includes(lower) || (entry.genericName && entry.genericName.toLowerCase().includes(lower)) || (entry.comment && entry.comment.toLowerCase().includes(lower)) || entry.keywords.some(kw => kw.toLowerCase().includes(lower));
                    }).sort((a, b) => {
                        const aStarts = a.name.toLowerCase().startsWith(lower);
                        const bStarts = b.name.toLowerCase().startsWith(lower);
                        if (aStarts && !bStarts)
                            return -1;
                        if (!aStarts && bStarts)
                            return 1;
                        return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
                    });
                }

                Component.onCompleted: {
                    applyFilter();
                }
            }
        }
    }
}
