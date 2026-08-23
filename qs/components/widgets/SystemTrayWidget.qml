import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../../theme" as Theme

RowLayout {
    id: root

    property var screen: null
    property int iconSize: Theme.Theme.iconSize + 4

    spacing: Theme.Theme.gap
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayIcon
            required property var modelData

            width: root.iconSize
            height: root.iconSize

            IconImage {
                anchors.fill: parent
                // modelData.icon is already a fully-resolved SNI icon
                // source (sometimes with an embedded ?path= icon-theme
                // search path) - don't re-resolve it through
                // Quickshell.iconPath(), which is for plain icon-theme
                // names and mangles the already-resolved string.
                source: trayIcon.modelData.icon
                asynchronous: true
            }

            TrayMenuOpener {
                id: menuOpener
                trayItem: trayIcon.modelData
                screen: root.screen
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton)
                        trayIcon.modelData.activate();
                    else if (mouse.button === Qt.MiddleButton)
                        trayIcon.modelData.secondaryActivate();
                    else if (mouse.button === Qt.RightButton && trayIcon.modelData.hasMenu)
                        menuOpener.openAt(trayIcon, mouse.x, mouse.y);
                }
                onWheel: (wheel) => trayIcon.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
