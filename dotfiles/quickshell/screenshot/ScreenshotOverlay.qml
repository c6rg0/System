//@ pragma Env QS_SCREENSHOT=1
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
// `.`, not `screenshot`: this file is inside the directory, so importing it by
// name resolves to a path that does not exist and logs a warning.
import "."
import ".."

// The full-screen freeze frame plus selection UI, one layer surface per output.
//
// This is a normal (threaded) layer surface rather than the ScreencopyView
// Quickshell.Wayland offers for monitor capture: a screencopy surface has to be
// rendered wholesale by the compositor, which disallows the rounded selection
// outline's shader, and it cannot render the capture above itself.
Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overlay

            readonly property bool isFocused: modelData.name === Screenshot.activeScreenName
            required property var modelData

            // On demand keeps the surface out of the keyboard focus stack until
            // it maps, so the Hyprland bind that started this isn't still held.
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs:screenshot"
            color: "transparent"
            exclusiveZone: -1
            screen: modelData
            visible: Screenshot.overlayVisible

            Variables {
                id: v
            }
            anchors {
                bottom: true
                left: true
                right: true
                top: true
            }

            // Deliberately no `mask` here. An empty Region mask does stop the
            // surface from taking pointer focus, but it also stops pointer
            // events from being delivered into the scene at all, which silently
            // kills the selection MouseArea. hypr/rules.lua already sets
            // `no_anim` on this namespace, which is what the mask was for.
            // Frozen desktop, behind the dimming layer drawn by RegionSelector.
            Image {
                anchors.fill: parent
                asynchronous: true
                cache: false
                fillMode: Image.PreserveAspectCrop
                source: Screenshot.tempPath ? "file://" + Screenshot.tempPath : ""
                sourceSize.height: overlay.height
                sourceSize.width: overlay.width
            }
            Item {
                id: content

                anchors.fill: parent

                Connections {
                    function onActiveChanged() {
                        if (!Screenshot.active)
                            selector.clearSelection();
                    }

                    // Once the capture is frozen, ask Hyprland where the cursor
                    // was so the guide crosshair starts under the pointer.
                    function onOverlayVisibleChanged() {
                        if (!Screenshot.overlayVisible || !overlay.isFocused)
                            return;
                        cursorPosProcess.running = true;
                    }

                    target: Screenshot
                }
                Process {
                    id: cursorPosProcess

                    command: ["hyprctl", "cursorpos", "-j"]
                    running: false

                    stdout: StdioCollector {
                        onStreamFinished: {
                            try {
                                const pos = JSON.parse(this.text.trim());
                                selector.updateMouse(pos.x - overlay.modelData.x, pos.y - overlay.modelData.y);
                            } catch (e) {
                                console.warn("Failed to parse cursorpos:", e);
                            }
                        }
                    }
                }
                RegionSelector {
                    id: selector

                    anchors.fill: parent
                    visible: Screenshot.mode === "region"

                    onPointerPressed: selector.canceled = false
                    onRegionSelected: (x, y, width, height) => {
                        Screenshot.saveScreenshot(x, y, width, height, overlay.modelData.name);
                    }
                }
                ControlBar {
                    id: controlBar

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter
                    editActive: Screenshot.editActive
                    mode: Screenshot.mode
                    modes: Screenshot.modes
                    tempActive: Screenshot.tempActive
                    visible: overlay.isFocused

                    onModeSelected: m => {
                        Screenshot.mode = m;
                    }
                }
                QuickToggle {
                    id: editToggleButton

                    active: Screenshot.editActive
                    backgroundColor: v.accentColor
                    // One action per bind, like the standalone overlay: turning
                    // the toggle on is what the keybind/click asks for, turning
                    // it off is done by the button again or by Temp.
                    behaviorOnDeactivate: false
                    borderColor: v.accentForeground
                    borderWidth: 1
                    iconColor: v.accentForeground
                    imageSource: Qt.resolvedUrl("icons/edit.svg")
                    shadowColor: v.shadowColor
                    sourceX: overlay.width / 2 - 204 + 32
                    targetX: (overlay.width - controlBar.targetMenuWidth) / 2 - 15 - width
                    targetY: controlBar.y + controlBar.height / 2
                    visible: overlay.isFocused

                    onClicked: Screenshot.toggleEdit()
                }
                QuickToggle {
                    id: tempToggleButton

                    active: Screenshot.tempActive
                    backgroundColor: v.accentColor
                    behaviorOnDeactivate: false
                    borderColor: v.accentForeground
                    borderWidth: 1
                    iconColor: v.accentForeground
                    imageSource: Qt.resolvedUrl("icons/temp.svg")
                    shadowColor: v.shadowColor
                    sourceX: overlay.width / 2 - 204 + 332
                    targetX: (overlay.width + controlBar.targetMenuWidth) / 2 + 15
                    targetY: controlBar.y + controlBar.height / 2
                    visible: overlay.isFocused

                    onClicked: Screenshot.toggleTemp()
                }
            }

            // The whole overlay is keyboard-modal while it's up, so the keys
            // below work on any monitor and the focused one only paints.
            Item {
                function handleKey(event) {
                    if (event.key === Qt.Key_Escape || event.key === Qt.Key_Q) {
                        Screenshot.cancel();
                        event.accepted = true;
                        return;
                    }

                    if (event.key === Qt.Key_S) {
                        Screenshot.saveScreenshot(0, 0, overlay.modelData.width, overlay.modelData.height, overlay.modelData.name);
                        event.accepted = true;
                        return;
                    }

                    if (event.key === Qt.Key_E) {
                        Screenshot.toggleEdit();
                        event.accepted = true;
                        return;
                    }

                    if (event.key === Qt.Key_T) {
                        Screenshot.toggleTemp();
                        event.accepted = true;
                    }
                }

                anchors.fill: parent
                focus: true

                Keys.onPressed: event => {
                    handleKey(event);
                }
            }
        }
    }
}
