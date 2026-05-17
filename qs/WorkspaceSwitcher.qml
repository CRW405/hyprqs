import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    Repeater {
        model: 10

        Text {
            property var ws: Hyprland.workspace.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

            text: index + 1
            color: isActive ? "red" : "white"

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}
