import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../common"
import "../icons"
import "../../theme" as Theme

RowLayout {
    id: root
    property real volume: 0
    property bool muted: false
    property color textColor: Theme.Theme.fg
    property color mutedColor: Theme.Theme.muted
    property int fontSize: Theme.Theme.fontSize
    property int iconSize: Theme.Theme.iconSize

    spacing: Theme.Theme.gap

    Process {
        id: wpctlProc
    }

    VolumeIcon {
        muted: root.muted
        color: root.muted ? root.mutedColor : root.textColor
        iconSize: root.iconSize
    }

    SlotText {
        widthSamples: ["100%", "Muted"]
        content: volumeText

        StyledText {
            id: volumeText
            text: root.muted ? "Muted" : Math.round(root.volume * 100) + "%"
            textColor: root.muted ? root.mutedColor : root.textColor
            fontSize: root.fontSize
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            wpctlProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
            wpctlProc.running = true;
        }
        onWheel: (wheel) => {
            wpctlProc.command = wheel.angleDelta.y > 0 ? ["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "1%+"] : ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%-"];
            wpctlProc.running = true;
        }
    }
}
