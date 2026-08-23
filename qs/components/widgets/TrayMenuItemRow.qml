import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

// One row in a TrayMenuOpener popup. `entry` is a DBusMenuItem (QsMenuEntry
// from QsMenuOpener.children, but concretely a DBusMenuItem for tray menus).
// Activation is done by calling entry.triggered() - that's a plain Qt
// signal, but calling it from QML emits it, which the object wires
// internally to the real D-Bus send. The seemingly-more-direct
// DBusMenuItem.sendTriggered() is NOT actually invokable from QML despite
// appearing in the qmltypes reflection (confirmed via a runtime TypeError -
// it's a C++-only method, not Q_INVOKABLE).
//
// This is a plain Item wrapping an inner RowLayout, rather than being a
// RowLayout itself - the MouseArea below sits above a full-screen
// click-outside-to-close catcher (see TrayMenuOpener.qml), and a MouseArea
// anchored to fill a Layout-managed item is undefined-geometry behavior
// (Qt warns about this) which let clicks fall through to that catcher
// instead of registering here.
//
// Submenu cascading (entry.hasChildren) is not implemented yet - the ">"
// indicator renders but is inert; treat as a fast-follow, not dropped scope.
Item {
    id: root

    required property var entry
    signal activated()

    Layout.fillWidth: true
    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    Rectangle {
        anchors.fill: parent
        visible: !entry.isSeparator
        color: mouseArea.containsMouse ? Theme.Theme.bgAlt : "transparent"
    }

    RowLayout {
        id: contentRow
        anchors.fill: parent
        spacing: Theme.Theme.gap

        Rectangle {
            visible: entry.isSeparator
            Layout.fillWidth: true
            height: 1
            color: Theme.Theme.muted
        }

        StyledText {
            visible: !entry.isSeparator
            Layout.fillWidth: true
            text: (entry.checkState === Qt.Checked ? "[x] " : "") + entry.text
            textColor: entry.enabled ? Theme.Theme.fg : Theme.Theme.muted
        }

        StyledText {
            visible: !entry.isSeparator && entry.hasChildren
            text: ">"
            textColor: Theme.Theme.muted
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: !entry.isSeparator && entry.enabled
        onClicked: {
            entry.triggered();
            root.activated();
        }
    }
}
