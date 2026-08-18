import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../common"
import "../icons"
import "../../theme" as Theme

RowLayout {
    id: root
    property string profile: "unknown"
    property var availableProfiles: []
    property color textColor: Theme.Theme.fg
    property int fontSize: Theme.Theme.fontSize
    property int iconSize: Theme.Theme.iconSize

    spacing: Theme.Theme.gap

    function nextProfile() {
        var list = root.availableProfiles
        if (!list || list.length === 0) {
            list = ["power-saver", "balanced", "performance"]
        }
        var idx = list.indexOf(root.profile)
        if (idx === -1) return list[0]
        return list[(idx + 1) % list.length]
    }

    Process {
        id: setProc
    }

    PowerProfileIcon {
        profile: root.profile
        color: root.textColor
        iconSize: root.iconSize
    }

    StyledText {
        text: root.profile
        textColor: root.textColor
        fontSize: root.fontSize
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var next = root.nextProfile()
            if (!next) return
            setProc.command = ["powerprofilesctl", "set", next]
            setProc.running = true
        }
    }
}
