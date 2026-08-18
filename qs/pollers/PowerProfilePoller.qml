import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: profilePoller
    property string profile: "unknown"
    property var availableProfiles: []

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
            }
        }

        Component.onCompleted: running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!profileProc.running) profileProc.running = true
    }
}
