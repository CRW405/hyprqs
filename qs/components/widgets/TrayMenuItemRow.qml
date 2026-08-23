import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

// entry is a DBusMenuItem. Submenus (entry.hasChildren) not implemented -
// the ">" is inert.
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
            entry.triggered(); // not sendTriggered() - that's not Q_INVOKABLE, throws
            root.activated();
        }
    }
}
