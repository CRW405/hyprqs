import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
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

    VolumePoller {
        id: volumePoller
    }

    NightLightPoller {
        id: nightLightPoller
    }

    NotificationServer {
        id: notificationServer

        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true
        onNotification: (notification) => {
            return notification.tracked = true;
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Scope {
                id: screenScope

                required property var modelData

                PanelWindow {
                    // TODO:
                    // Figure out what to do about not enough space
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
                    // Commented code catcher:
                    // anchors.fill: parent
                    // spacing: gap

                    id: barWindow

                    property bool showCpuFahrenheit: false
                    property bool showGpuFahrenheit: false

                    screen: screenScope.modelData
                    anchors.top: true
                    anchors.left: true
                    anchors.right: true
                    implicitHeight: Theme.Theme.barHeight
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

                        SystemTrayWidget {
                            screen: screenScope.modelData
                        }

                        Seperator {
                        }

                        MediaControls {
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
                            id: clock
                        }

                        Seperator {
                        }

                    }

                    Item {
                        id: rightSection

                        anchors.left: middleSection.right
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.Theme.gap
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        clip: true

                        RowLayout {
                            id: pinnedRow

                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: Theme.Theme.gap

                            Seperator {
                            }

                            NotificationIndicator {
                                id: notificationIndicator

                                unreadCount: notificationServer.trackedNotifications.values.length
                            }

                        }

                        Flickable {
                            id: rightScrollArea

                            anchors.left: parent.left
                            anchors.right: pinnedRow.left
                            anchors.rightMargin: Theme.Theme.gap
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            contentWidth: scrollContent.implicitWidth
                            contentHeight: height
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            flickableDirection: Flickable.HorizontalFlick

                            WheelHandler {
                                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                onWheel: (event) => {
                                    const delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x;
                                    rightScrollArea.contentX = Math.max(0, Math.min(rightScrollArea.contentWidth - rightScrollArea.width, rightScrollArea.contentX - delta));
                                }
                            }

                            RowLayout {
                                id: scrollContent

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

                                UsageLabel {
                                    label: "M: "
                                    value: memPoller.memUsage
                                    append: "%"
                                }

                                Seperator {
                                }

                                VolumeWidget {
                                    volume: volumePoller.volume
                                    muted: volumePoller.muted
                                }

                                Seperator {
                                }

                                NightLightButton {
                                    nightLightEnabled: nightLightPoller.nightLightEnabled
                                    onToggleRequested: nightLightPoller.toggle()
                                }

                                Seperator {
                                    visible: batteryPoller.hasBattery
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
                                    visible: batteryPoller.hasBattery
                                }

                                PowerProfileButton {
                                    profile: powerProfilePoller.profile
                                    availableProfiles: powerProfilePoller.availableProfiles
                                    visible: batteryPoller.hasBattery && powerProfilePoller.availableProfiles.length > 0
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

                PanelWindow {
                    id: calendarWindow

                    screen: screenScope.modelData
                    anchors.top: true
                    anchors.left: true
                    anchors.right: true
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    property bool hoverActive: clock.hovered || calendarPopup.hovered
                    visible: hoverActive || calendarCloseTimer.running
                    implicitHeight: calendarPopup.implicitHeight
                    margins.top: Theme.Theme.barHeight
                    onHoverActiveChanged: hoverActive ? calendarCloseTimer.stop() : calendarCloseTimer.start()

                    Timer {
                        id: calendarCloseTimer
                        interval: 300
                    }

                    CalendarPopup {
                        id: calendarPopup

                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                }

                PanelWindow {
                    id: notificationWindow

                    screen: screenScope.modelData
                    anchors.top: true
                    anchors.left: true
                    anchors.right: true
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    property bool hoverActive: notificationIndicator.hovered || notificationPopup.hovered
                    visible: hoverActive || notificationCloseTimer.running
                    implicitHeight: notificationPopup.implicitHeight
                    margins.top: Theme.Theme.barHeight
                    onHoverActiveChanged: hoverActive ? notificationCloseTimer.stop() : notificationCloseTimer.start()

                    Timer {
                        id: notificationCloseTimer
                        interval: 300
                    }

                    NotificationPopup {
                        id: notificationPopup

                        notifServer: notificationServer
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.Theme.gap
                    }

                }

                PanelWindow {
                    id: toastWindow

                    screen: screenScope.modelData
                    anchors.top: true
                    anchors.right: true
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    visible: toastStack.count > 0
                    implicitWidth: 320
                    implicitHeight: toastStack.implicitHeight
                    margins.top: Theme.Theme.barHeight + Theme.Theme.gap
                    margins.right: Theme.Theme.gap

                    Connections {
                        target: notificationServer
                        function onNotification(notification) {
                            toastStack.show(notification);
                        }
                    }

                    NotificationToastStack {
                        id: toastStack
                    }

                }

            }

        }

    }

}
