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
        topLevel.openSubmenu(-1, null);
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

        TrayMenuLevel {
            id: topLevel
            x: root.menuX
            y: Theme.Theme.barHeight
            menu: root.rootMenuItem
            closeAll: root.close
        }
    }
}
