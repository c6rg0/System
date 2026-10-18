import QtQuick
import QtQuick.Effects
import ".."

// Round icon button that springs between an off-screen "source" position and
// its slot in the toolbar, used for the Edit and Temp toggles.
Rectangle {
    id: root

    property bool active: false
    readonly property real activeIconSize: 30
    property color backgroundColor: v.accentColor
    // Off by default here: these buttons toggle on click/keypress, and a false
    // toggle should not queue a second action on the way out.
    property bool behaviorOnDeactivate: false
    property color borderColor: "transparent"
    property int borderWidth: 0
    readonly property real buttonSize: 44
    readonly property int fadeDuration: 250
    property bool hovered: false
    property color iconColor: v.accentForeground
    property url imageSource: ""
    readonly property real inactiveIconSize: 20
    readonly property real inactiveScale: 0.4
    property color shadowColor: v.shadowColor
    property real sourceX: 0
    property real targetX: 0
    property real targetY: 0

    signal clicked

    antialiasing: true
    border.color: borderColor
    border.width: borderWidth
    color: backgroundColor
    height: buttonSize
    opacity: active ? 1 : 0
    radius: buttonSize / 2
    scale: active ? (hovered ? 1.1 : 1) : inactiveScale
    visible: active || opacity > 0
    width: buttonSize
    x: active ? targetX : sourceX
    y: targetY - height / 2

    Behavior on opacity {
        NumberAnimation {
            duration: root.fadeDuration
            easing.type: Easing.OutQuad
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutBack
        }
    }
    Behavior on x {
        SpringAnimation {
            damping: 0.4
            mass: 0.8
            spring: 4
        }
    }
    Behavior on y {
        SpringAnimation {
            damping: 0.4
            mass: 0.8
            spring: 4
        }
    }

    onActiveChanged: {
        if (!active)
            hovered = false;
    }

    Variables {
        id: v
    }
    Item {
        id: iconContainer

        anchors.centerIn: parent
        height: width
        width: root.active ? root.activeIconSize : root.inactiveIconSize

        Behavior on width {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuad
            }
        }

        Image {
            id: iconImage

            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            mipmap: true
            smooth: true
            source: root.imageSource
            sourceSize.height: height
            sourceSize.width: width
            visible: false
        }
        MultiEffect {
            anchors.fill: iconImage
            colorization: 1
            colorizationColor: root.iconColor
            source: iconImage
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: root.active
        hoverEnabled: true

        onClicked: {
            if (root.behaviorOnDeactivate)
                root.active = false;
            root.clicked();
        }
        onEntered: root.hovered = true
        onExited: root.hovered = false
    }
}
