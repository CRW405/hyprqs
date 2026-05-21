import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    property string profile: "unknown"
    property var availableProfiles: []

    spacing: 4

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
        color: "white"
    }

    Text {
        text: root.profile
        color: "white"
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
