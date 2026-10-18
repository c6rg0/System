import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import "../"

Item {
    id: thumbContainer

    // If true, the thumbnail will animate from workspace position to layout position
    property bool animateIn: root.animateWindows
    property var clientInfo: {}
    property var hWin: null
    property bool hovered: false
    property real targetRotation: 0
    property real targetX: -1000
    property real targetY: -1000
    property real targetZ: 0
    property real thumbH: -1
    property real thumbW: -1
    property var wHandle: null
    property string winKey: ''

    function activateWindow() {
        if (!hWin)
            return;
        var targetIsSpecial = (hWin?.workspace ?? 0) < 0 || (hWin?.workspace?.name ?? "").startsWith("special");

        if (root.specialActive && !targetIsSpecial) {
            Hyprland.dispatch('hl.dsp.workspace.toggle_special()');
        }

        if (hWin.workspace) {
            root.closingWorkspace = hWin.workspace;
            hWin.workspace.activate();
        }
        root.toggleExpose();

        Hyprland.dispatch('hl.dsp.focus({ window = "address:0x' + hWin.address + '"})');
        Hyprland.dispatch('hl.dsp.window.alter_zorder({ mode = "top" })');
    }

    // Used for close animation: respects explicit closingWorkspace, falls back accordingly
    function isOnClosingWorkspace() {
        if (!hWin || !hWin.workspace)
            return false;
        var cw = root.closingWorkspace;
        if (cw) {
            // Explicit target: if it's a special workspace, match by name
            if (cw.id < 0)
                return hWin.workspace.name === cw.name;
            return hWin.workspace.id === cw.id;
        }
        // No explicit target: use current state
        if (root.specialActive && root.specialWorkspaceName)
            return hWin.workspace.name === root.specialWorkspaceName;
        var focused = Hyprland.focusedWorkspace;
        if (!focused)
            return false;
        return hWin.workspace.id === focused.id;
    }
    function isOnFocusedWorkspace() {
        if (!hWin || !hWin.workspace)
            return false;
        // When a special workspace is active, match its windows by name
        if (root.specialActive && root.specialWorkspaceName)
            return hWin.workspace.name === root.specialWorkspaceName;
        var focused = Hyprland.focusedWorkspace;
        if (!focused)
            return false;
        return hWin.workspace.id === focused.id;
    }

    // Called by Hyprview when expose is closing. Triggers reverse animations.
    function startCloseAnimation() {
        startAnim.stop();
        fadeInAnim.stop();
        if (isOnClosingWorkspace()) {
            var wsW = Math.max(clientInfo && clientInfo.size ? clientInfo.size[0] : thumbW, 50);
            var wsH = Math.max(clientInfo && clientInfo.size ? clientInfo.size[1] : thumbH, 50);
            var localCenter = workspaceToLocalCenter();
            if (localCenter) {
                closeAnimX.to = localCenter.x - wsW / 2;
                closeAnimY.to = localCenter.y - wsH / 2;
                closeAnimW.to = wsW;
                closeAnimH.to = wsH;
                closeAnim.start();
            } else {
                fadeOutAnim.start();
            }
        } else {
            fadeOutAnim.start();
        }
    }
    function updateLastPos() {
        var lp = root.lastPositions || ({});
        var prev = lp[winKey] || ({});
        prev.x = x;
        prev.y = y;
        lp[winKey] = prev;
        root.lastPositions = lp;
    }

    // Map the window's screen-space center to exposeArea-local coords
    function workspaceToLocalCenter() {
        if (!clientInfo || !clientInfo.at || clientInfo.at[0] <= -1000) {
            return null;
        }
        var parentItem = thumbContainer.parent;
        if (!parentItem) {
            return null;
        }
        var screenCX = (clientInfo.at[0] || 0) + (clientInfo.size[0] || 0) / 2;
        var screenCY = (clientInfo.at[1] || 0) + (clientInfo.size[1] || 0) / 2;
        return parentItem.mapFromItem(null, screenCX, screenCY);
    }

    height: thumbH
    rotation: 0
    visible: !!wHandle
    width: thumbW
    x: 0
    y: 0
    z: targetZ

    Component.onCompleted: {
        rotation = targetRotation;

        if (root.animateWindows && root.isActive && !!wHandle) {
            var onFocused = isOnFocusedWorkspace();
            if (onFocused) {
                var wsW = Math.max(clientInfo && clientInfo.size ? clientInfo.size[0] : thumbW, 50);
                var wsH = Math.max(clientInfo && clientInfo.size ? clientInfo.size[1] : thumbH, 50);
                var localCenter = workspaceToLocalCenter();
                if (localCenter) {
                    // Start at actual workspace size (unclamped — exposeArea has clip:false)
                    width = wsW;
                    height = wsH;
                    // Center on the window's screen position
                    x = localCenter.x - wsW / 2;
                    y = localCenter.y - wsH / 2;
                    startAnim.restart();
                } else {
                    x = targetX;
                    y = targetY;
                }
            } else {
                // Not on focused workspace: snap to final position, fade in
                x = targetX;
                y = targetY;
                opacity = 0;
                fadeInAnim.start();
            }
        } else {
            x = targetX;
            y = targetY;
        }
        updateLastPos();
    }
    onTargetRotationChanged: {
        rotation = targetRotation;
    }
    onTargetXChanged: {
        if (!startAnim.running && !closeAnim.running) {
            x = targetX;
        }
        updateLastPos();
    }
    onTargetYChanged: {
        if (!startAnim.running && !closeAnim.running) {
            y = targetY;
        }
        updateLastPos();
    }
    onXChanged: updateLastPos()
    onYChanged: updateLastPos()

    Variables {
        id: v
    }
    RectangularShadow {
        anchors.fill: card
        blur: 16
        color: Qt.rgba(0, 0, 0, 0.35)
        radius: 4
        spread: 0
        visible: true
    }

    // Open animation: from workspace position/size to layout position/size
    ParallelAnimation {
        id: startAnim

        PropertyAnimation {
            duration: 400
            easing.type: Easing.OutCubic
            property: "x"
            target: thumbContainer
            to: targetX
        }
        PropertyAnimation {
            duration: 400
            easing.type: Easing.OutCubic
            property: "y"
            target: thumbContainer
            to: targetY
        }
        PropertyAnimation {
            duration: 400
            easing.type: Easing.OutCubic
            property: "width"
            target: thumbContainer
            to: thumbW
        }
        PropertyAnimation {
            duration: 400
            easing.type: Easing.OutCubic
            property: "height"
            target: thumbContainer
            to: thumbH
        }
    }

    // Close animation: focused workspace windows animate back to workspace position
    ParallelAnimation {
        id: closeAnim

        PropertyAnimation {
            id: closeAnimX

            duration: 400
            easing.type: Easing.OutCubic
            property: "x"
            target: thumbContainer
        }
        PropertyAnimation {
            id: closeAnimY

            duration: 400
            easing.type: Easing.OutCubic
            property: "y"
            target: thumbContainer
        }
        PropertyAnimation {
            id: closeAnimW

            duration: 400
            easing.type: Easing.OutCubic
            property: "width"
            target: thumbContainer
        }
        PropertyAnimation {
            id: closeAnimH

            duration: 400
            easing.type: Easing.OutCubic
            property: "height"
            target: thumbContainer
        }
    }

    // Fade-in for windows not on the focused workspace (open)
    PropertyAnimation {
        id: fadeInAnim

        duration: 400
        easing.type: Easing.OutCubic
        from: 0
        property: "opacity"
        target: thumbContainer
        to: 1
    }

    // Fade-out for off-workspace windows (close)
    PropertyAnimation {
        id: fadeOutAnim

        duration: 400
        easing.type: Easing.OutCubic
        property: "opacity"
        target: thumbContainer
        to: 0
    }
    Item {
        id: card

        anchors.fill: parent
        scale: 1
        transformOrigin: Item.Center

        MouseArea {
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: event => {
                exposeArea.currentIndex = index;

                thumbContainer.activateWindow();
            }
            onEntered: {
                exposeArea.currentIndex = index;
            }
            onExited: {
                if (exposeArea.currentIndex === index) {
                    exposeArea.currentIndex = -1;
                }
            }
        }
        Loader {
            id: thumbLoader

            active: root.isActive && !!thumbContainer.wHandle
            anchors.fill: parent

            sourceComponent: ScreencopyView {
                id: thumb

                anchors.fill: parent
                captureSource: thumbContainer.wHandle
                layer.enabled: true
                live: root.isActive
                paintCursor: false
                visible: root.isActive && thumbContainer.wHandle && hasContent

                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        height: thumb.height
                        radius: 12
                        width: thumb.width
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    border.color: "#444"
                    border.width: thumbContainer.hovered ? 4 : 1
                    color: "transparent"
                    radius: 12
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "#333333"
                radius: 12
            }
        }
        Rectangle {
            id: badge

            color: thumbContainer.hovered ? v.accentColor : "#e4e7ef"
            height: titleText.implicitHeight + 12
            radius: 4
            width: Math.min(titleText.implicitWidth + 24, thumbContainer.thumbW * 0.75)
            x: (card.width - width) / 2
            y: card.height - height - (card.height * 0.08)
            z: 100

            Text {
                id: titleText

                anchors.centerIn: parent
                color: thumbContainer.hovered ? "#fff" : "#222"
                elide: Text.ElideRight
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                text: hWin.title
                verticalAlignment: Text.AlignVCenter
                width: parent.width - 16
            }
        }
    }
}
