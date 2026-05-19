import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    MemPoller {
        id: memPoller
    }

    CpuPoller {
        id: cpuPoller
    }

    CpuTempPoller {
        id: cpuTempPoller
    }

    GpuTempPoller {
        id: gpuTempPoller
    }

    StoragePoller {
        id: storagePoller
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: barWindow

                required property var modelData
                property bool showCpuFahrenheit: false
                property bool showGpuFahrenheit: false

                screen: modelData
                anchors.top: true
                anchors.left: true
                anchors.right: true
                implicitHeight: 25
                color: "grey"

                RowLayout {
                    // TODO:
                    // System Logo or User Logo or Profile Picture
                    // Notifications
                    // System Tray
                    // Hover time to see calender
                    // Idle Inhibitor
                    // Toggle cpu and ram labels for different modes such as mem amount and core
                    // Volume manager
                    // Night Light / HyprSunset Manager
                    // cava integration
                    // Dashboard dropdown:
                    //      Notifications
                    //      picture thing
                    //      media controls
                    //      audio controls
                    //      settings:
                    //          Bluetooth
                    //          Wifi
                    //          Power / logout options

                    anchors.fill: parent

                    WorkspaceSwitcher {
                    }

                    Clock {
                    }

                    UsageLabel {
                        label: "CPU: "
                        value: cpuPoller.cpuUsage
                        append: "%"
                    }

                    UsageLabel {
                        label: "Mem: "
                        value: memPoller.memUsage
                        append: "%"
                    }

                    TempToggleLabel {
                        label: "CPU: "
                        tempC: cpuTempPoller.tempC
                        tempF: cpuTempPoller.tempF
                        onClicked: barWindow.showCpuFahrenheit = !barWindow.showCpuFahrenheit
                    }

                    TempToggleLabel {
                        label: "GPU: "
                        tempC: gpuTempPoller.tempC
                        tempF: gpuTempPoller.tempF
                        onClicked: barWindow.showGpuFahrenheit = !barWindow.showGpuFahrenheit
                    }

                    DiskUsageLabel {
                        label: "Disk: "
                        usedStorage: storagePoller.usedStorage
                        totalStorage: storagePoller.totalStorage
                        percentage: storagePoller.percentage
                    }

                }

            }

        }

    }

}
