import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    property int cpuUsage: 0
    property int memUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    PanelWindow {
        id: barWindow
        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: 20
        color: "transparent"

        RowLayout {
            anchors.fill: parent

            // Workspaces
            Repeater {
                model: 10
                Text {
                    property var ws: Hyprland.workspace.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    text: index + 1
                    color: isActive ? "red" : "white"
                    font {
                        pixelSize: 20
                        bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index+1))
                    }
                }
            }

            Text {
                text: "CPU: " + root.cpuUsage + "%"
                color: root.cpuUsage > 80 ? "red" : "white"
            }

            Text {
                text: "Mem: " + root.memUsage + "%"
                color: root.memUsage > 80 ? "red" : "white"
            }

            Text {
                id: clock
                color: "white"
                text: Qt.formatDateTime(new Date(), "hh:mm:ss - MM/dd/yyyy")
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        clock.text = Qt.formatDateTime(new Date(), "hh:mm:ss - MM/dd/yyyy")
                    }
                }
            }
        }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1,8).reduce((a,b) => a + parseInt(b), 0)

                if (root.lastCpuTotal > 0) {
                    root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)))
                }
                root.lastCpuTotal = total
                root.lastCpuIdle = idle
            }
        }
        Component.onCompleted: running = true // loop
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                root.memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }


    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
        }
    }
}
