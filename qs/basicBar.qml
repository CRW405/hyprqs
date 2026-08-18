import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "pollers"
import "components/widgets"
import "components/labels"
import "components/common"
import "theme" as Theme

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
                // TODO:
                // click audio controls on cava: left to go back, middle to pause, right to skip, scroll to adjust volume
                // center items in slots on bar, ex: center time text no matter length
                // Notifications
                // System Tray
                // Hover time to see calender
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
                // ---
                // TODO FIX:
                // Worskpace manager icon misalignment
                // cava rounding even at 0
                // ---
                // Commentede code catcher:
                // anchors.fill: parent
                // spacing: gap

                id: barWindow

                required property var modelData
                property bool showCpuFahrenheit: false
                property bool showGpuFahrenheit: false

                screen: modelData
                anchors.top: true
                anchors.left: true
                anchors.right: true
                height: Theme.Theme.barHeight
                color: Theme.Theme.bg

                RowLayout {
                    id: leftSection

                    anchors.left: parent.left
                    anchors.leftMargin: Theme.Theme.gap
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.Theme.gap

                    WorkspaceSwitcher {
                    }

                    Seperator {
                    }

                    CavaBars {
                    }

                }

                RowLayout {
                    id: middleSection

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.Theme.gap

                    Seperator {
                    }

                    Clock {
                    }

                    Seperator {
                    }

                }

                RowLayout {
                    id: rightSection

                    anchors.right: parent.right
                    anchors.rightMargin: Theme.Theme.gap
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.Theme.gap

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
                        label: "D: "
                        usedStorage: storagePoller.usedStorage
                        totalStorage: storagePoller.totalStorage
                        percentage: storagePoller.percentage
                    }

                    Seperator {
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
