import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property bool open: true
    property color color: Theme.Theme.fg
    property int iconWidth: Theme.Theme.iconSize + 2
    property int iconHeight: Math.round(iconWidth * 0.6)

    width: iconWidth
    height: iconHeight

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "transparent"
        border.width: 1
        border.color: root.color
    }

    Rectangle {
        width: height / 2
        height: height / 2
        radius: height / 4
        anchors.centerIn: parent
        color: root.color
        visible: root.open
    }

    Rectangle {
        width: parent.width / 3
        height: 2
        anchors.centerIn: parent
        color: root.color
        visible: !root.open
    }

}
