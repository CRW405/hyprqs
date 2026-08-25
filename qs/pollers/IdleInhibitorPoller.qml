import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: inhibitorPoller
    property bool inhibitEnabled: false

    // --who= for systemd-inhibit, and the pkill -f pattern to stop it again
    readonly property string inhibitorTag: "quickshell-idle-inhibitor"

    // Re-detects real state (e.g. after Quickshell restarts while an
    // inhibitor from a previous run is still alive) instead of assuming off.
    function refresh() {
        if (!detectProc.running) detectProc.running = true
    }

    function toggle() {
        if (inhibitorPoller.inhibitEnabled) {
            if (!stopProc.running) stopProc.running = true
        } else {
            if (!startProc.running) startProc.running = true
        }
    }

    Process {
        id: detectProc
        command: ["pgrep", "-f", inhibitorPoller.inhibitorTag]
        stdout: StdioCollector {
            onStreamFinished: {
                inhibitorPoller.inhibitEnabled = this.text.trim().length > 0
            }
        }
    }

    // Held open for as long as the inhibitor should apply; hypridle honors
    // it via general.ignore_dbus_inhibit = false in hypr/hypridle.conf.
    Process {
        id: startProc
        command: [
            "systemd-inhibit",
            "--what=idle",
            "--who=" + inhibitorPoller.inhibitorTag,
            "--why=Idle inhibitor toggled from bar",
            "--mode=block",
            "sleep", "infinity"
        ]
        onRunningChanged: if (running) inhibitorPoller.inhibitEnabled = true
    }

    Process {
        id: stopProc
        command: ["pkill", "-f", inhibitorPoller.inhibitorTag]
        onExited: inhibitorPoller.refresh()
    }

    Component.onCompleted: inhibitorPoller.refresh()
}
