import QtQuick
import Quickshell.Io
import "../common"
import "../../theme" as Theme

Rectangle {
    id: root

    property bool hovered: false
    readonly property int popupPadding: Theme.Theme.gap * 3

    function ansiToRichText(raw) {
        var withSpan = raw.replace(/\x1b\[7m/g, "<span style=\"color:" + Theme.Theme.accent + ";\">").replace(/\x1b\[0m/g, "</span>");
        return "<pre style=\"margin:0;\">" + withSpan + "</pre>";
    }

    color: Theme.Theme.bg
    border.color: Theme.Theme.muted
    border.width: 1
    implicitWidth: label.implicitWidth + popupPadding * 2
    implicitHeight: label.implicitHeight + popupPadding * 2

    StyledText {
        id: label

        anchors.centerIn: parent
        textFormat: Text.RichText
        text: ""
    }

    Process {
        id: calProc

        command: ["cal", "--color=always", "--year"]
        Component.onCompleted: running = true

        stdout: StdioCollector {
            onStreamFinished: label.text = root.ansiToRichText(this.text)
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
    }

}
