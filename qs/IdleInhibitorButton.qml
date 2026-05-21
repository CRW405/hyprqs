import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    property bool inhibitEnabled: false
    signal toggleRequested()

    spacing: 4

    EyeIcon {
        open: root.inhibitEnabled
        color: root.inhibitEnabled ? "red" : "white"
    }

    Text {
        text: root.inhibitEnabled ? "Inhibit" : "Idle"
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.toggleRequested()
        }
    }
}
