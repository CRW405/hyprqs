import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: poller
    property int tempC: 0
    property int tempF: 0

    Process {
        id: gpuProc
        // Loops through hwmon folders, finds 'amdgpu', and reads its temperature file
        command: ["sh", "-c", "for d in /sys/class/hwmon/hwmon*; do if grep -q 'amdgpu' $d/name 2>/dev/null; then cat $d/temp1_input; break; fi; done"]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var raw = parseInt(data.trim())
                if (!isNaN(raw)) {
                    poller.tempC = Math.round(raw / 1000)
                    poller.tempF = Math.round(poller.tempC * 9/5 + 32)
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: gpuProc.running = true
    }
}
