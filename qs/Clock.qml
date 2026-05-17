import QtQuick

Text {
    id: clock
    property bool showDetailed: false
    color: "white"
    text: ""

    function updateText() {
        var now = new Date()
        if (clock.showDetailed) {
            var day = Qt.formatDateTime(now, "ddd")
            clock.text = day + " - " + Qt.formatDateTime(now, "hh:mm:ss - MM/dd/yyyy")
        } else {
            clock.text = Qt.formatDateTime(now, "hh:mm")
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            clock.showDetailed = !clock.showDetailed
            clock.updateText()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.updateText()
    }

    Component.onCompleted: clock.updateText()
}
