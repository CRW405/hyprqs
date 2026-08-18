import QtQuick
import "../../theme" as Theme

Item {
    id: root
    property string profile: "balanced"
    property color color: Theme.Theme.fg
    property int iconSize: Theme.Theme.iconSize
    property int fontSize: Math.max(8, Math.round(iconSize * 0.7))

    width: iconSize
    height: iconSize

    Rectangle {
        anchors.fill: parent
        radius: 3
        color: "transparent"
        border.width: 1
        border.color: root.color
    }

    Text {
        anchors.centerIn: parent
        text: root.profile === "performance" ? "P" : (root.profile === "power-saver" ? "S" : (root.profile === "balanced" ? "B" : "?"))
        color: root.color
        font.pixelSize: root.fontSize
    }
}
