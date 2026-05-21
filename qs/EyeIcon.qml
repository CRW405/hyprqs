import QtQuick

Item {
    id: root
    property bool open: true
    property color color: "white"

    width: 18
    height: 10

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
        width: parent.width - 4
        height: 2
        anchors.centerIn: parent
        color: root.color
        visible: !root.open
    }
}
