import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: profilePoller
    property string profile: "unknown"
    property var availableProfiles: []
    property bool pending: false

    // Applies `name` optimistically for instant feedback, then refreshes as
    // soon as the change lands instead of waiting for the next 5s poll tick.
    function setProfile(name) {
        if (!name) return
        profilePoller.profile = name
        profilePoller.pending = true
        setProc.command = ["powerprofilesctl", "set", name]
        setProc.running = true
    }

    Process {
        id: profileProc
        command: [
            "sh",
            "-c",
            "active=$(powerprofilesctl get 2>/dev/null || echo unknown); "
                + "profiles=$(powerprofilesctl list 2>/dev/null | sed -n 's/^[* ]*\\([a-z-]\\+\\):.*/\\1/p' | paste -sd, -); "
                + "if [ -z \"$profiles\" ]; then "
                + "  echo \"unknown|\"; "
                + "else "
                + "  echo \"$active|$profiles\"; "
                + "fi"
        ]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var line = data.trim()
                if (!line) return
                var parts = line.split("|")
                profilePoller.profile = parts[0] ? parts[0].trim() : "unknown"
                profilePoller.availableProfiles = (parts.length > 1 && parts[1])
                    ? parts[1].split(",").map(p => p.trim()).filter(p => p.length > 0)
                    : []
                profilePoller.pending = false
            }
        }

        Component.onCompleted: running = true
    }

    Process {
        id: setProc
        onExited: if (!profileProc.running) profileProc.running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!profileProc.running) profileProc.running = true
    }
}
