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

    BatteryPoller {
        id: batteryPoller
    }

    BatteryStatusPoller {
        id: batteryStatusPoller
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

    PowerProfilePoller {
        id: powerProfilePoller
    }

    IdleInhibitorPoller {
        id: idleInhibitorPoller
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
                    // Notifications
                    // System Tray
                    // Hover time to see calender
                    // Toggle cpu and ram labels for different modes such as mem amount and core
                    // Volume manager
                    // Night Light / HyprSunset Manager
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

                    CavaBars {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Clock {
                    }

                    BatteryWidget {
                        percentage: batteryPoller.percentage
                        charging: batteryPoller.isCharging
                        visible: batteryPoller.hasBattery
                    }

                    BatteryStatusLabel {
                        status: batteryStatusPoller.status
                        timeToFullSec: batteryStatusPoller.timeToFullSec
                        hasBattery: batteryStatusPoller.hasBattery
                        visible: batteryStatusPoller.hasBattery
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
                        showFahrenheit: barWindow.showCpuFahrenheit
                        onClicked: barWindow.showCpuFahrenheit = !barWindow.showCpuFahrenheit
                    }

                    TempToggleLabel {
                        label: "GPU: "
                        tempC: gpuTempPoller.tempC
                        tempF: gpuTempPoller.tempF
                        showFahrenheit: barWindow.showGpuFahrenheit
                        onClicked: barWindow.showGpuFahrenheit = !barWindow.showGpuFahrenheit
                    }

                    DiskUsageLabel {
                        label: "Disk: "
                        usedStorage: storagePoller.usedStorage
                        totalStorage: storagePoller.totalStorage
                        percentage: storagePoller.percentage
                    }

                    PowerProfileButton {
                        profile: powerProfilePoller.profile
                        availableProfiles: powerProfilePoller.availableProfiles
                        visible: powerProfilePoller.availableProfiles.length > 0
                    }

                    IdleInhibitorButton {
                        inhibitEnabled: idleInhibitorPoller.inhibitEnabled
                        onToggleRequested: idleInhibitorPoller.toggle()
                    }

                }

            }

        }

    }

}
