import QtQuick
import "../common"

StyledText {
    id: root

    property bool showDetailed: true
    property bool hovered: false

    function updateText() {
        var now = new Date();
        if (root.showDetailed) {
            var day = Qt.formatDateTime(now, "dddd");
            root.text = day + " - " + Qt.formatDateTime(now, "hh:mm:ss A - MM/dd/yyyy");
        } else {
            root.text = Qt.formatDateTime(now, "hh:mm A");
        }
    }

    text: ""
    Component.onCompleted: root.updateText()

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: {
            root.showDetailed = !root.showDetailed;
            root.updateText();
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateText()
    }

}
