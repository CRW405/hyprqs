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

    Seperator {
        id: seperator
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: barWindow

                required property var modelData
                property bool showCpuFahrenheit: false
                property bool showGpuFahrenheit: false
                property var fontSize: 12
                property var fontColor: "#FFFFFF"

                screen: modelData
                anchors.top: true
                anchors.left: true
                anchors.right: true
                implicitHeight: 25
                color: "#222222"

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

                    Seperator {
                    }

                    CavaBars {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Seperator {
                    }

                    Clock {
                    }

                    Seperator {
                    }

                    BatteryWidget {
                        percentage: batteryPoller.percentage
                        charging: batteryPoller.isCharging
                        visible: batteryPoller.hasBattery
                    }

                    Seperator {
                    }

                    BatteryStatusLabel {
                        status: batteryStatusPoller.status
                        timeToFullSec: batteryStatusPoller.timeToFullSec
                        hasBattery: batteryStatusPoller.hasBattery
                        visible: batteryStatusPoller.hasBattery
                    }

                    Seperator {
                    }

                    UsageLabel {
                        label: "C: "
                        value: cpuPoller.cpuUsage
                        append: "%"
                    }

                    TempToggleLabel {
                        tempC: cpuTempPoller.tempC
                        tempF: cpuTempPoller.tempF
                        showFahrenheit: barWindow.showCpuFahrenheit
                        onClicked: barWindow.showCpuFahrenheit = !barWindow.showCpuFahrenheit
                    }

                    Seperator {
                    }

                    UsageLabel {
                        label: "M: "
                        value: memPoller.memUsage
                        append: "%"
                    }

                    Seperator {
                    }

                    TempToggleLabel {
                        label: "G: "
                        tempC: gpuTempPoller.tempC
                        tempF: gpuTempPoller.tempF
                        showFahrenheit: barWindow.showGpuFahrenheit
                        onClicked: barWindow.showGpuFahrenheit = !barWindow.showGpuFahrenheit
                    }

                    Seperator {
                    }

                    DiskUsageLabel {
                        // percentage: storagePoller.percentage

                        label: "D: "
                        usedStorage: storagePoller.usedStorage
                        totalStorage: storagePoller.totalStorage
                    }

                    Seperator {
                    }

                    PowerProfileButton {
                        profile: powerProfilePoller.profile
                        availableProfiles: powerProfilePoller.availableProfiles
                        visible: powerProfilePoller.availableProfiles.length > 0
                    }

                    Seperator {
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
