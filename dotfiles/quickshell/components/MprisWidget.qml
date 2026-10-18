import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.popups.mpris
import ".."

Item {
    id: root

    readonly property var player: {
        let players = Mpris.players.values;
        if (players.length === 0)
            return null;
        for (let i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing)
                return players[i];
        }
        return players[0];
    }
    readonly property string playerIcon: {
        if (!player)
            return "";
        if (player.playbackState === MprisPlaybackState.Paused)
            return "󰏤";
        let id = player.identity.toLowerCase();
        if (id.includes("spotify"))
            return "󰓇";
        if (id.includes("io"))
            return "󰫔";
        if (id.includes("firefox"))
            return "";
        return "󰎈";
    }
    readonly property string trackTitle: {
        if (!player)
            return "";
        let t = player.trackTitle ?? "";
        return t.length > 16 ? t.substring(0, 14) + " ..." : t;
    }

    Layout.fillHeight: true
    Layout.leftMargin: 10
    implicitWidth: visible ? (mprisLabel.implicitWidth + 20) : 0
    visible: Mpris.players.values.length > 0

    Variables {
        id: v
    }
    Rectangle {
        anchors.fill: parent
        color: mprisPopup.visible ? v.widgetHighlight : "transparent"
        radius: 6
    }
    Text {
        id: mprisLabel

        anchors.centerIn: parent
        color: root.player?.playbackState === MprisPlaybackState.Playing ? v.textColor : v.textSecondary
        elide: Text.ElideRight
        font.family: "SF Pro"
        font.pixelSize: 19
        font.weight: 400
        renderType: Text.NativeRendering
        text: root.player ? root.playerIcon + "    " + root.trackTitle : ""
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            mprisPopup.visible = !mprisPopup.visible;
            mprisPopup.updatesEnabled = mprisPopup.visible;
            root.player.positionChanged();
        }
    }
    MprisPopup {
        id: mprisPopup

        player: root.player
        visible: false
    }
}
