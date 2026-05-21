import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: cpuPoller
    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return

                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)

                if (cpuPoller.lastCpuTotal > 0) {
                    cpuPoller.cpuUsage = Math.round(100 * (1 - (idle - cpuPoller.lastCpuIdle) / (total - cpuPoller.lastCpuTotal)))
                }

                cpuPoller.lastCpuTotal = total
                cpuPoller.lastCpuIdle = idle
            }
        }

        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: if (!cpuProc.running) cpuProc.running = true
    }
}
