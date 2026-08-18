import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: statusPoller
    property bool hasBattery: false
    property string status: "Unknown"
    property int timeToFullSec: 0

    Process {
        id: statusProc
        command: [
            "sh",
            "-c",
            "for b in /sys/class/power_supply/BAT*; do "
                + "  [ -d \"$b\" ] || continue; "
                + "  present=$(cat \"$b/present\" 2>/dev/null || echo 1); "
                + "  [ \"$present\" = \"1\" ] || continue; "
                + "  status=$(cat \"$b/status\" 2>/dev/null || echo \"Unknown\"); "
                + "  t=\"\"; "
                + "  if [ \"$status\" = \"Charging\" ] || [ \"$status\" = \"Full\" ]; then "
                + "    if [ -f \"$b/time_to_full_now\" ]; then "
                + "      t=$(cat \"$b/time_to_full_now\" 2>/dev/null || echo \"\"); "
                + "    fi; "
                + "  fi; "
                + "  echo \"$status|$t\"; "
                + "  exit 0; "
                + "done; "
                + "echo NONE"
        ]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var line = data.trim()
                if (!line) return

                if (line === "NONE") {
                    statusPoller.hasBattery = false
                    statusPoller.status = "Unknown"
                    statusPoller.timeToFullSec = 0
                    return
                }

                var parts = line.split("|")
                statusPoller.status = parts[0] ? parts[0].trim() : "Unknown"
                statusPoller.hasBattery = true

                var timeVal = 0
                if (parts.length > 1 && parts[1]) {
                    var parsed = parseInt(parts[1])
                    if (!isNaN(parsed)) timeVal = parsed
                }
                statusPoller.timeToFullSec = timeVal
            }
        }

        Component.onCompleted: running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!statusProc.running) statusProc.running = true
    }
}
