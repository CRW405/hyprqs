import QtQuick

Item {
    id: root
    property string profile: "balanced"
    property color color: "white"

    width: 16
    height: 16

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
        font.pixelSize: 10
    }
}
