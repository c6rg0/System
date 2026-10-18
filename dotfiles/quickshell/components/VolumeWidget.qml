import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import ".."
import qs.popups.volume

Item {
    id: root

    readonly property string iconName: {
        if (muted || volume === 0.0)
            return "audio-volume-muted";
        if (volume < 0.34)
            return "audio-volume-low";
        if (volume < 0.67)
            return "audio-volume-medium";
        return "audio-volume-high";
    }
    readonly property bool muted: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.muted : false
    readonly property real volume: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0.0

    Layout.fillHeight: true
    Layout.leftMargin: 8
    implicitWidth: icon.implicitWidth + 24

    Variables {
        id: v
    }
    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }
    Rectangle {
        id: volumeWidget

        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 3
        color: volumePopup.visible ? v.widgetHighlight : "transparent"
        radius: 6
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            volumePopup.visible = !volumePopup.visible;
        }
    }
    IconImage {
        id: icon

        anchors.centerIn: parent
        implicitSize: 27
        source: Qt.resolvedUrl("../share/icons/" + root.iconName + "-symbolic.svg")
        visible: true
    }
    VolumePopup {
        id: volumePopup

        visible: false
    }
}
