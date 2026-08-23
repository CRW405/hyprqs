import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

RowLayout {
    id: root
    property bool nightLightEnabled: false
    property color textColor: Theme.Theme.fg
    property color activeColor: Theme.Theme.accent
    property int fontSize: Theme.Theme.fontSize
    signal toggleRequested()

    spacing: Theme.Theme.gap

    SlotText {
        widthSamples: ["Night", "Day"]
        content: nightLightText

        StyledText {
            id: nightLightText
            text: root.nightLightEnabled ? "Night" : "Day"
            textColor: root.nightLightEnabled ? root.activeColor : root.textColor
            fontSize: root.fontSize
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggleRequested()
    }
}
