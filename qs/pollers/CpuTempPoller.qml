import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: poller
    property int tempF: 0
    property int tempC: 0

    Process {
        id: tempProc
        // Loops through hwmon folders, checks if the name is k10temp or coretemp, then reads temp1_input
        command: ["sh", "-c", "for d in /sys/class/hwmon/hwmon*; do if grep -qE '(k10temp|coretemp)' $d/name 2>/dev/null; then cat $d/temp1_input 2>/dev/null || cat $d/temp2_input; break; fi; done"]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var rawTemp = parseInt(data.trim())
                if (!isNaN(rawTemp)) {
                    poller.tempC = Math.round(rawTemp / 1000)
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
        onTriggered: if (!tempProc.running) tempProc.running = true
    }
}
