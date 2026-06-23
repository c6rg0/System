import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.share.corners

Scope {
    id: root
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panelWindow
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs:screencorners"
            required property var modelData
            property int radius: 8
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            exclusiveZone: -1
            mask: Region {}
            color: "transparent"

            readonly property bool suppressCorners:
                ToplevelManager.activeToplevel?.fullscreen ?? false

            visible: !suppressCorners

            Loader {
                active: !panelWindow.suppressCorners
                sourceComponent: ScreenCornersVisible {}
            }
            ScreenCornersVisible {}
        }
    }
}
