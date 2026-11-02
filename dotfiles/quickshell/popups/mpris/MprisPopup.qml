import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import Quickshell.Widgets
import Quickshell.Hyprland
import "../.."

PanelWindow {
    id: root
    WlrLayershell.namespace: "qs:popup"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    color: "transparent"
    exclusionMode: "Ignore"
    implicitHeight: contentColumn.implicitHeight + 64
    implicitWidth: 340
    margins.left: popupX
    margins.top: 32
    updatesEnabled: false

    readonly property string album: player?.trackAlbum ?? ""
    property string albumPlaceholder: "image://share/media-album-cover"
    readonly property string artUrl: player?.trackArtUrl ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property bool canNext: player?.canGoNext ?? false
    readonly property bool canPause: player?.canPause ?? false
    readonly property bool canPlay: player?.canPlay ?? false
    readonly property bool canPrev: player?.canGoPrevious ?? false
    readonly property bool canSeek: player?.canSeek ?? false
    readonly property real length: player?.length ?? 0
    property var player: null
    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing
    property real popupX: mprisLabel.mapToItem(null, 0, 0).x + mprisLabel.width / 2 - width / 2
    readonly property real position: player?.position ?? 0
    readonly property string title: player?.trackTitle ?? ""

    function formatMs(totalSec) {
        const m = Math.floor(totalSec / 60);
        const s = Math.floor(totalSec % 60);
        return m + ":" + String(s).padStart(2, "0");
    }

    HyprlandFocusGrab {
        active: root.visible
        windows: [root]
        onCleared: root.visible = false
    }
    Variables {
        id: v
    }
    anchors {
        left: true
        top: true
    }
    Connections {
        function onWidthChanged() {
            repositionTimer.restart();
        }

        target: mprisLabel
    }
    Timer {
        id: repositionTimer

        interval: 1
        repeat: false

        onTriggered: {
            root.popupX = mprisLabel.mapToItem(null, 0, 0).x + mprisLabel.width / 2 - root.width / 2;
        }
    }
    Rectangle {
        id: card

        anchors.fill: parent
        color: "transparent"
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
            id: mprisBorder

            anchors.fill: parent
            anchors.margins: 16
            border.color: v.popupBorder
            border.width: 1
            color: v.popupBackground
            radius: parent.radius
        }
        Rectangle {
            id: cardOuterBorder

            anchors.fill: parent
            anchors.margins: 15
            border.color: v.outerBorderColor
            border.width: 1
            color: 'transparent'
            radius: card.radius
        }
        ColumnLayout {
            id: contentColumn

            spacing: 0

            anchors {
                left: parent.left
                margins: 36
                right: parent.right
                top: parent.top
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 4
                Layout.preferredHeight: width    // square; image adapts
                Layout.rightMargin: 4
                Layout.topMargin: 4
                color: "transparent"
                visible: true

                RectangularShadow {
                    anchors.fill: parent
                    blur: 8
                    color: Qt.rgba(0, 0, 0, 0.1)
                    radius: 10
                    spread: 4
                }
                ClippingRectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10

                    Image {
                        id: artImage

                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        mipmap: true
                        source: root.player.trackArtUrl != null ? root.player.trackArtUrl : root.albumPlaceholder
                    }
                }
                Text {
                    anchors.centerIn: parent
                    color: "#333"
                    font.pixelSize: 64
                    text: "♫"
                    visible: artImage.status !== Image.Ready
                }
                MouseArea {
                    id: mouseArea

                    anchors.fill: parent
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    hoverEnabled: true

                    onClicked: {
                        root.player?.raise();
                        root.visible = false;
                    }
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: 20
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    color: "#fff"
                    elide: Text.ElideRight
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    text: root.title
                }
                Text {
                    Layout.fillWidth: true
                    color: v.textColor
                    elide: Text.ElideRight
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    text: [root.artist, root.album].filter(Boolean).join("  ·  ")
                    visible: root.artist.length > 0 || root.album.length > 0
                }
            }
            Timer {
                interval: 1000
                repeat: true
                running: playing && root.visible && !seekSlider.pressed

                onTriggered: player.positionChanged()
            }
            Slider {
                id: seekSlider

                Layout.fillWidth: true
                Layout.leftMargin: 0
                Layout.rightMargin: 0
                Layout.topMargin: 12
                enabled: root.player !== null && root.length > 0
                from: 0
                height: 20
                /*
                to: root.player.length
                value: root.player.position
                */
                to: Math.max(root.length, 1)
                value: Math.min(root.position, to)

                background: Rectangle {
                    border.color: v.widgetHighlight
                    border.width: 1
                    color: "#30303030"
                    height: 14
                    radius: 7
                    width: seekSlider.availableWidth
                    x: seekSlider.leftPadding
                    y: seekSlider.topPadding + seekSlider.availableHeight / 2 - height / 2

                    ClippingRectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        color: "transparent"
                        radius: 7

                        Rectangle {
                            color: "#ffffff"
                            height: parent.height
                            width: seekSlider.visualPosition * (parent.width)
                        }
                    }
                }
                handle: Rectangle {
                    color: "transparent"
                }

                onMoved: {
                    player.position = player.length * seekSlider.visualPosition;
                }
            }
            RowLayout {
                Layout.bottomMargin: 6
                Layout.fillWidth: true
                Layout.leftMargin: 4
                Layout.rightMargin: 4
                Layout.topMargin: 2

                Text {
                    color: v.textColor
                    font.pixelSize: 10
                    text: formatMs(root.position)
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    color: v.textColor
                    font.pixelSize: 10
                    text: root.length > 0 ? formatMs(root.length) : "-:--"
                }
            }
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: controlRow.implicitHeight

                RowLayout {
                    id: controlRow

                    anchors.centerIn: parent
                    spacing: 4
                    width: implicitWidth

                    //TODO: Set the below icons to white or/and make them more visible

                    // Previous
                    ControlButton {
                        icon: "⏮"
                        size: 64

                        onActivated: root.player?.previous()
                    }

                    // Play / Pause
                    ControlButton {
                        icon: root.playing ? "⏸" : "▶"
                        size: 64

                        onActivated: root.playing ? root.player?.pause() : root.player?.play()
                    }

                    // Next
                    ControlButton {
                        icon: "⏭"
                        size: 64

                        onActivated: root.player?.next()
                    }
                }
            }
        } // ColumnLayout
    } // card Rectangle

}
