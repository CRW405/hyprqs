import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../theme" as Theme

// One flyout box in a tray menu. Recursively instantiates itself to the
// right of whichever row is hovered and has children (entry.hasChildren).
Rectangle {
    id: level

    // Not `required`: nested levels are loaded dynamically via Loader.source
    // (see below) and get these assigned post-construction via Binding.
    property var menu: null // QsMenuHandle
    property var closeAll: null // function() to close the whole tray menu

    property int activeIndex: -1
    property var activeEntry: null

    // DBusMenu submenus are populated lazily - the backend only sends
    // children after it receives an "opened" (AboutToShow) event, so we
    // have to notify the entry before its children will show up.
    function openSubmenu(index, entry) {
        if (level.activeEntry === entry)
            return;
        if (level.activeEntry && typeof level.activeEntry.sendClosed === "function")
            level.activeEntry.sendClosed();
        level.activeIndex = index;
        level.activeEntry = entry;
        if (entry) {
            if (typeof entry.updateLayout === "function")
                entry.updateLayout();
            if (typeof entry.sendOpened === "function")
                entry.sendOpened();
        }
    }

    Component.onDestruction: {
        if (level.activeEntry && typeof level.activeEntry.sendClosed === "function")
            level.activeEntry.sendClosed();
    }

    color: Theme.Theme.bg
    border.color: Theme.Theme.muted
    border.width: 1
    implicitWidth: column.implicitWidth + Theme.Theme.gap * 2
    implicitHeight: column.implicitHeight + Theme.Theme.gap * 2

    QsMenuOpener {
        id: opener
        menu: level.menu
    }

    ColumnLayout {
        id: column
        anchors.centerIn: parent
        spacing: 2

        Repeater {
            id: rowRepeater
            model: opener.children

            delegate: TrayMenuItemRow {
                required property var modelData
                required property int index
                entry: modelData
                onActivated: level.closeAll()
                onHoverEntered: level.openSubmenu(index, modelData.hasChildren ? modelData : null)
            }
        }
    }

    Loader {
        id: submenuLoader

        // Can't instantiate TrayMenuLevel inline here - QML rejects a type
        // directly nesting itself ("instantiated recursively"). Loading it
        // by URL defers resolution to runtime instead of static type-checking.
        active: level.activeEntry !== null
        source: Qt.resolvedUrl("TrayMenuLevel.qml")
        x: level.width + 2
        y: {
            const row = rowRepeater.itemAt(level.activeIndex);
            return row ? column.y + row.y : 0;
        }

        Binding {
            target: submenuLoader.item
            when: submenuLoader.item !== null
            property: "menu"
            value: level.activeEntry
        }

        // closeAll holds a function - Binding's property-write path rejects
        // functions on anything but a plain assignment, so set it imperatively.
        onLoaded: item.closeAll = level.closeAll
    }
}
