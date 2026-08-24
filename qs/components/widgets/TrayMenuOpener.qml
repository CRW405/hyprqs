import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../theme" as Theme

Item {
    id: root

    property var trayItem: null
    property var screen: null
    property bool menuVisible: false
    property real menuX: 0

    // don't drill into trayItem.menu.menu - trayItem.menu is already the QsMenuHandle
    readonly property var rootMenuItem: trayItem && trayItem.hasMenu ? trayItem.menu : null

    function openAt(anchorItem, x, y) {
        menuX = anchorItem.mapToItem(null, x, y).x;
        if (rootMenuItem && typeof rootMenuItem.updateLayout === "function")
            rootMenuItem.updateLayout();
        if (rootMenuItem && typeof rootMenuItem.sendOpened === "function")
            rootMenuItem.sendOpened();
        menuVisible = true;
    }

    function close() {
        if (rootMenuItem && typeof rootMenuItem.sendClosed === "function")
            rootMenuItem.sendClosed();
        menuVisible = false;
    }

    QsMenuOpener {
        id: opener
        menu: root.rootMenuItem || null
    }

    PanelWindow {
        id: menuWindow
        screen: root.screen
        visible: root.menuVisible
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        anchors.top: true
        anchors.left: true
        anchors.right: true
        anchors.bottom: true

        // click-outside-to-close catcher, behind menuBg
        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }

        Rectangle {
            id: menuBg
            x: root.menuX
            y: Theme.Theme.barHeight
            color: Theme.Theme.bg
            border.color: Theme.Theme.muted
            border.width: 1
            implicitWidth: menuColumn.implicitWidth + Theme.Theme.gap * 2
            implicitHeight: menuColumn.implicitHeight + Theme.Theme.gap * 2

            HoverHandler {
                onHoveredChanged: if (!hovered)
                    root.close()
            }

            ColumnLayout {
                id: menuColumn
                anchors.centerIn: parent
                spacing: 2

                Repeater {
                    model: opener.children

                    delegate: TrayMenuItemRow {
                        required property var modelData
                        entry: modelData
                        onActivated: root.close()
                    }
                }
            }
        }
    }
}
