import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

RowLayout {
    id: root
    property bool inhibitEnabled: false
    property color textColor: Theme.Theme.fg
    property color activeColor: Theme.Theme.warn
    property int fontSize: Theme.Theme.fontSize
    signal toggleRequested()

    spacing: Theme.Theme.gap

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
