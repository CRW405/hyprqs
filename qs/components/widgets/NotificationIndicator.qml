import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

RowLayout {
    id: root

    property int unreadCount: 0
    property bool hovered: false
    property color textColor: Theme.Theme.fg
    property color activeColor: Theme.Theme.accent

    spacing: Theme.Theme.gap

    StyledText {
        text: "N: " + root.unreadCount
        textColor: root.unreadCount > 0 ? root.activeColor : root.textColor
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
    }
}
