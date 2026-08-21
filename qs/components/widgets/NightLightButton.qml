import QtQuick
import QtQuick.Layouts
import "../common"
import "../icons"
import "../../theme" as Theme

RowLayout {
    id: root
    property bool nightLightEnabled: false
    property color textColor: Theme.Theme.fg
    property color activeColor: Theme.Theme.accent
    property int fontSize: Theme.Theme.fontSize
    property int iconSize: Theme.Theme.iconSize
    signal toggleRequested()

    spacing: Theme.Theme.gap

    NightLightIcon {
        active: root.nightLightEnabled
        color: root.nightLightEnabled ? root.activeColor : root.textColor
        iconSize: root.iconSize
    }

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
