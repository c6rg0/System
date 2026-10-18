import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import ".."

// The OSD pill itself: an icon plus a progress bar. Purely presentational —
// Osd.qml owns the visibility timing and decides what is shown.
Item {
    id: root

    property color accent: v.textColor
    property real bump: 0
    // +1 when pushed past the top, -1 when pushed past the bottom.
    property int bumpDirection: 1
    readonly property real bumpGrow: 0.06
    // Kept small enough to stay inside OsdWindow's shadowMargin.
    readonly property real bumpNudge: 9

    //  At-limit spring
    property int bumpToken: 0
    property string iconName: "audio-volume-high"
    readonly property real progress: Math.max(0, Math.min(1, value))
    property real radius: 16
    property real value: 0

    implicitHeight: 64
    implicitWidth: 300

    transform: [
        Scale {
            origin.x: root.width / 2
            xScale: 1 + root.bumpGrow * root.bump
        },
        Translate {
            x: root.bumpDirection * root.bumpNudge * root.bump
        }
    ]

    onBumpTokenChanged: bumpAnim.restart()

    Variables {
        id: v
    }
    SequentialAnimation {
        id: bumpAnim

        // Quick shove in the direction of the push...
        NumberAnimation {
            duration: 160
            easing.type: Easing.OutQuad
            property: "bump"
            target: root
            to: 1
        }
        // ...then spring back, overshooting a little before it settles.
        NumberAnimation {
            duration: 500
            easing.amplitude: 1.2
            easing.period: 0.8
            easing.type: Easing.OutElastic
            property: "bump"
            target: root
            to: 0
        }
    }
    Rectangle {
        id: card

        anchors.fill: parent
        border.color: v.popupBorder
        border.width: 1
        color: v.popupBackground
        radius: root.radius

        // Inner highlight
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            border.color: v.widgetHighlight
            border.width: 1
            color: "transparent"
            radius: card.radius - 1
        }
    }
    IconImage {
        id: icon

        anchors.verticalCenter: parent.verticalCenter
        implicitSize: 36
        source: Qt.resolvedUrl("../share/icons/" + root.iconName + "-symbolic.svg")
        x: 18
    }

    //  Progress track
    Rectangle {
        id: track

        anchors.left: icon.right
        anchors.leftMargin: 16
        anchors.right: card.right
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        color: v.widgetHighlight
        height: 10
        radius: 5

        ClippingRectangle {
            anchors.fill: parent
            anchors.margins: 0
            color: "transparent"
            radius: parent.radius

            Rectangle {
                color: root.accent
                height: parent.height
                radius: 18
                width: root.progress * parent.width
            }
        }
    }
}
