import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

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


                required property var modelData
                screen: modelData

        id: barWindow
        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: 20
        color: "grey"
        property bool showCpuFahrenheit: false
        property bool showGpuFahrenheit: false

        RowLayout {
            anchors.fill: parent

            WorkspaceSwitcher {}

            UsageLabel {
                label: "CPU"
                value: cpuPoller.cpuUsage
            }

            UsageLabel {
                label: "Mem"
                value: memPoller.memUsage
            }

            TempToggleLabel {
                label: "CPU Temp"
                tempC: cpuTempPoller.tempC
                tempF: cpuTempPoller.tempF
                showFahrenheit: barWindow.showCpuFahrenheit
                onClicked: barWindow.showCpuFahrenheit = !barWindow.showCpuFahrenheit
            }

            TempToggleLabel {
                label: "GPU Temp"
                tempC: gpuTempPoller.tempC
                tempF: gpuTempPoller.tempF
                showFahrenheit: barWindow.showGpuFahrenheit
                onClicked: barWindow.showGpuFahrenheit = !barWindow.showGpuFahrenheit
            }

            DiskUsageLabel {
                usedStorage: storagePoller.usedStorage
                totalStorage: storagePoller.totalStorage
                percentage: storagePoller.percentage
            }


            Clock {}
        }
    }
}
}
}
