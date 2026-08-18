import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: batteryPoller
    property bool hasBattery: false
    property int percentage: 0
    property string status: "Unknown"
    property bool isCharging: false

    Process {
        id: batteryProc
        command: [
            "sh",
            "-c",
            "for b in /sys/class/power_supply/BAT*; do "
                + "  [ -d \"$b\" ] || continue; "
                + "  present=$(cat \"$b/present\" 2>/dev/null || echo 1); "
                + "  [ \"$present\" = \"1\" ] || continue; "
                + "  cap=$(cat \"$b/capacity\" 2>/dev/null || echo \"\"); "
                + "  status=$(cat \"$b/status\" 2>/dev/null || echo \"Unknown\"); "
                + "  if [ -n \"$cap\" ]; then echo \"$cap|$status\"; exit 0; fi; "
                + "done; "
                + "echo NONE"
        ]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var line = data.trim()
                if (!line) return

                if (line === "NONE") {
                    batteryPoller.hasBattery = false
                    batteryPoller.percentage = 0
                    batteryPoller.status = "Unknown"
                    batteryPoller.isCharging = false
                    return
                }

                var parts = line.split("|")
                var cap = parseInt(parts[0])
                if (!isNaN(cap)) batteryPoller.percentage = cap
                var status = parts.length > 1 && parts[1] ? parts[1].trim() : "Unknown"
                batteryPoller.status = status
                batteryPoller.hasBattery = true
                batteryPoller.isCharging = status === "Charging"
            }
        }

        Component.onCompleted: running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!batteryProc.running) batteryProc.running = true
    }
}
