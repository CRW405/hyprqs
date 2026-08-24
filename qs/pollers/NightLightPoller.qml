import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    property bool nightLightEnabled: false
    readonly property string stateFile: Quickshell.env("HOME") + "/.cache/.hyprsunset_state"
    readonly property string scriptPath: Quickshell.env("HOME") + "/.config/hypr/hypr/scripts/Hyprsunset.sh"

    function refresh() {
        if (!stateProc.running)
            stateProc.running = true
    }

    function toggle() {
        root.nightLightEnabled = !root.nightLightEnabled
        if (!toggleProc.running)
            toggleProc.running = true
    }

    Process {
        id: stateProc
        command: ["cat", root.stateFile]

        stdout: StdioCollector {
            onStreamFinished: root.nightLightEnabled = this.text.trim() === "on"
        }

        Component.onCompleted: running = true
    }

    Process {
        id: toggleProc
        command: [root.scriptPath, "toggle"]
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()
}
