import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../theme" as Theme

// Per-tray-icon right-click context menu. Mirrors basicBar.qml's
// calendarWindow dropdown pattern (a sibling PanelWindow anchored below the
// bar), but click-triggered rather than hover-triggered, and needs precise
// horizontal placement under the icon that opened it rather than a simple
// center-anchor.
Item {
    id: root

    property var trayItem: null
    property var screen: null
    property bool menuVisible: false
    property real menuX: 0

    // trayItem.menu is already a QsMenuHandle-compatible object (its
    // concrete C++ type isn't the same "DBusMenuHandle" exported by the
    // Quickshell.DBusMenu module - confirmed at runtime, not from static
    // reflection, since it isn't separately registered/documented). Feed it
    // straight into QsMenuOpener; don't drill into a nested `.menu`.
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

        // Click-outside-to-close catcher spanning the whole screen, behind
        // the menu itself. A right-click on a bar icon leaves the mouse
        // above where the menu opens (below the bar), so hover-exit alone
        // never fires - this is what actually closes the menu.
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

            // Closes the menu once the cursor has entered it and then left
            // again - doesn't fire on open itself, since the cursor starts
            // above the menu (over the bar icon that opened it) and
            // HoverHandler only reacts to hovered actually changing.
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
