import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: poller
    property string usedStorage: "0"
    property string totalStorage: "0"
    property int percentage: 0

    Process {
        id: storageProc
        // Grabs the row details specifically for the root '/' partition
        command: ["sh", "-c", "df -h / | tail -n 1"]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return

                // Splits strings by arbitrary whitespace lengths
                var parts = data.trim().split(/\s+/)
                if (parts.length >= 5) {
                    poller.totalStorage = parts[1] // e.g., "934G"
                    poller.usedStorage = parts[2]  // e.g., "420G"
                    poller.percentage = parseInt(parts[4].replace("%", "")) // e.g., 45
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 10000 // Storage fills slowly; a 10-second poll interval is plenty
        running: true
        repeat: true
        onTriggered: storageProc.running = true
    }
}
