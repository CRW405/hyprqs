import QtQuick
import QtQuick.Layouts
import "../common"
import "../icons"
import "../../theme" as Theme

RowLayout {
    id: root
    property bool inhibitEnabled: false
    property color textColor: Theme.Theme.fg
    property color activeColor: Theme.Theme.warn
    property int fontSize: Theme.Theme.fontSize
    property int iconWidth: Theme.Theme.iconSize + 2
    property int iconHeight: Math.round(iconWidth * 0.6)
    signal toggleRequested()

    spacing: Theme.Theme.gap

    EyeIcon {
        open: root.inhibitEnabled
        color: root.inhibitEnabled ? root.activeColor : root.textColor
        iconWidth: root.iconWidth
        iconHeight: root.iconHeight
    }

    StyledText {
        text: root.inhibitEnabled ? "Inhibit" : "Idle"
        textColor: root.textColor
        fontSize: root.fontSize
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggleRequested()
    }
}
