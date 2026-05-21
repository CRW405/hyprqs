import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: inhibitorPoller
    property bool inhibitEnabled: false

    function refresh() {
        if (!inhibitorProc.running) inhibitorProc.running = true
    }

    function toggle() {
        inhibitorPoller.inhibitEnabled = !inhibitorPoller.inhibitEnabled
        if (!toggleProc.running) toggleProc.running = true
    }

    function parseValue(raw) {
        if (typeof raw === "number") return raw
        if (typeof raw === "boolean") return raw ? 1 : 0
        if (typeof raw === "string") {
            var num = parseInt(raw)
            if (!isNaN(num)) return num
            if (raw.toLowerCase() === "true") return 1
            if (raw.toLowerCase() === "false") return 0
        }
        return 0
    }

    Process {
        id: inhibitorProc
        command: ["hyprctl", "-j", "getoption", "misc:idle_inhibit"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text) return
                try {
                    var parsed = JSON.parse(this.text)
                    var val = 0
                    if (parsed && typeof parsed.int !== "undefined") val = inhibitorPoller.parseValue(parsed.int)
                    else if (parsed && typeof parsed.value !== "undefined") val = inhibitorPoller.parseValue(parsed.value)
                    else if (parsed && typeof parsed.str !== "undefined") val = inhibitorPoller.parseValue(parsed.str)
                    else if (parsed && typeof parsed.data !== "undefined") val = inhibitorPoller.parseValue(parsed.data)
                    inhibitorPoller.inhibitEnabled = val === 1 || val === true
                } catch (e) {
                    inhibitorPoller.inhibitEnabled = false
                }
            }
        }

        Component.onCompleted: running = true
    }

    Process {
        id: toggleProc
        command: ["hyprctl", "dispatch", "toggleinhibit"]
    }

    Component.onCompleted: inhibitorPoller.refresh()
}
