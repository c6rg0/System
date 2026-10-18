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

            required property var modelData
            property int radius: 8
            readonly property bool suppressCorners: ToplevelManager.activeToplevel?.fullscreen ?? false

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs:screencorners"
            color: "transparent"
            exclusiveZone: -1
            screen: modelData
            visible: !suppressCorners

            mask: Region {
            }

            anchors {
                bottom: true
                left: true
                right: true
                top: true
            }
            Loader {
                active: !panelWindow.suppressCorners

                sourceComponent: ScreenCornersVisible {
                }
            }
            ScreenCornersVisible {
            }
        }
    }
}
