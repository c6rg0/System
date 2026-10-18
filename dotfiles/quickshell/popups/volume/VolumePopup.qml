import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.share.menu
import "../.."

PopupWindow {
    id: root

    // ── pipewire nodes ───────────────────────────────────────────────────────
    // Every audio node currently in the graph. Node type/name/description are
    // parsed from the registry global before the node lands in `nodes`, so
    // filtering on them here is safe.
    readonly property var audioNodes: Pipewire.nodes ? Pipewire.nodes.values.filter(node => node.audio !== null) : []
    readonly property var inputNodes: audioNodes.filter(node => (node.type & PwNodeType.AudioSource) === PwNodeType.AudioSource && (node.type & PwNodeType.Stream) === 0)

    // Device names can be arbitrarily long; keep every row inside the popup.
    readonly property int maxLabelLength: 30

    // Device subsets. PwNodeType flags are bitwise, so a duplex device (both
    // sink and source) legitimately shows up in both lists. Streams are the
    // applications playing/capturing audio and are excluded here.
    readonly property var outputNodes: audioNodes.filter(node => (node.type & PwNodeType.AudioSink) === PwNodeType.AudioSink && (node.type & PwNodeType.Stream) === 0)
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    function deviceLabel(node) {
        const name = node.description || node.nickname || node.name || "Unknown";
        return name.length > maxLabelLength ? name.substring(0, maxLabelLength - 1) + "…" : name;
    }

    color: "transparent"
    grabFocus: true
    implicitHeight: menuColumn.implicitHeight + 8
    implicitWidth: 360

    Variables {
        id: v
    }
    anchor {
        edges: Edges.Bottom
        item: volumeWidget
        rect.x: 16 - volumeWidget.width / 2
        rect.y: 38
    }

    // Bind the nodes so volume/mute/properties stay live.
    PwObjectTracker {
        objects: root.audioNodes
    }
    Item {
        id: mask

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            anchors.topMargin: 0
            color: "#fff"
            radius: 8
        }
    }
    RectangularShadow {
        id: outerShadow

        anchors.fill: parent
        blur: 10
        color: v.shadowColor
        radius: dropdown.radius
        spread: -8
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
        id: dropdown

        anchors.fill: parent
        anchors.margins: 8
        anchors.topMargin: 0
        border.color: v.popupBorder
        border.width: 1
        color: v.popupBackground
        radius: 8
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 7
        anchors.topMargin: -1
        border.color: v.outerBorderColor
        border.width: 1
        color: "transparent"
        radius: dropdown.radius
    }

    // ── menu contents ────────────────────────────────────────────────────────
    ColumnLayout {
        id: menuColumn

        spacing: 0

        anchors {
            bottomMargin: 4
            left: dropdown.left
            leftMargin: 0
            right: dropdown.right
            rightMargin: 0
            top: dropdown.top
            topMargin: 4
        }
        Rectangle {
            Layout.fillWidth: true
            color: "transparent"
            implicitHeight: 10
        }
        MenuLabel {
            label: "Sound"
            labelElement.font.family: "SF Pro"
            labelElement.font.weight: 600
        }
        Slider {
            id: seekSlider

            Layout.bottomMargin: 14
            Layout.fillWidth: true
            Layout.leftMargin: 18
            Layout.rightMargin: 18
            enabled: root.sink !== null
            from: 0
            height: 40
            to: 1
            value: root.sink && root.sink.audio ? root.sink.audio.volume : 0

            background: Rectangle {
                border.color: v.widgetHighlight
                border.width: 1
                color: "#30303030"
                height: 28
                radius: 14
                width: seekSlider.availableWidth
                x: seekSlider.leftPadding
                y: seekSlider.topPadding + seekSlider.availableHeight / 2 - height / 2

                ClippingRectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    radius: 14

                    Rectangle {
                        color: "#ffffff"
                        height: parent.height
                        width: seekSlider.visualPosition * (parent.width - 24) + 12
                    }
                }
            }
            handle: Rectangle {
                border.color: "#30606060"
                color: "#f0f0f0"
                implicitHeight: 28
                implicitWidth: 28
                radius: 14
                x: seekSlider.leftPadding + (seekSlider.availableWidth - 28) * seekSlider.visualPosition
                y: seekSlider.topPadding + seekSlider.availableHeight / 2 - height / 2
            }

            onMoved: {
                if (root.sink && root.sink.audio)
                    root.sink.audio.volume = seekSlider.visualPosition;
            }
        }
        MenuDiv {
        }

        // ── no devices placeholder ───────────────────────────────────────
        Loader {
            Layout.fillWidth: true
            visible: root.audioNodes.length === 0

            sourceComponent: Item {
                implicitHeight: 36

                Text {
                    anchors.centerIn: parent
                    color: v.textPlaceholder
                    font.pixelSize: 13
                    text: "No audio devices found"
                }
            }
        }

        // ── output devices (pipewire sinks) ──────────────────────────────
        MenuLabel {
            label: "Output"
            labelElement.color: v.textPlaceholder
            labelElement.font.family: "SF Pro"
            labelElement.font.weight: 600
            visible: root.outputNodes.length > 0
        }
        Repeater {
            model: root.outputNodes

            delegate: IconItem {
                required property var modelData
                readonly property PwNode node: modelData

                iconName: "audio-speakers-symbolic"
                label: root.deviceLabel(node)
                labelElement.font.family: "SF Pro"
                selected: node === root.sink

                onTriggered: Pipewire.preferredDefaultAudioSink = node
            }
        }

        // ── input devices (pipewire sources) ─────────────────────────────
        MenuLabel {
            label: "Input"
            labelElement.color: v.textPlaceholder
            labelElement.font.family: "SF Pro"
            labelElement.font.weight: 600
            visible: root.inputNodes.length > 0
        }
        Repeater {
            model: root.inputNodes

            delegate: IconItem {
                required property var modelData
                readonly property PwNode node: modelData

                iconName: "audio-input-microphone-symbolic"
                label: root.deviceLabel(node)
                labelElement.font.family: "SF Pro"
                selected: node === root.source

                onTriggered: Pipewire.preferredDefaultAudioSource = node
            }
        }
        MenuDiv {
        }
        MenuItem {
            label: "Sound Settings..."
            labelElement.font.family: "SF Pro"

            onTriggered: {
                // preferences.running = true;
                root.visible = false;
            }
        }
        /*
        Process {
            id: preferences
            command: ["bash", "-c", "kcmshell6 kcm_pulseaudio"]
            running: false
        }
        */

        // bottom padding
        Item {
            Layout.preferredHeight: 8
        }
    }
}
