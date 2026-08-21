import QtQuick
import Quickshell.Io
import "../common"
import "../../theme" as Theme

// Shows the output of `cal --year` (whole-year calendar) while hovering
// the Clock. cal highlights today via ANSI reverse-video (\x1b[7m ... \x1b[0m);
// that gets swapped for a color span in the accent color below. The span is
// wrapped in <pre> so RichText doesn't collapse the padding spaces cal uses
// to line up columns.
Rectangle {
    id: root
    color: Theme.Theme.bg
    border.color: Theme.Theme.muted
    border.width: 1

    readonly property int popupPadding: Theme.Theme.gap * 3

    implicitWidth: label.implicitWidth + popupPadding * 2
    implicitHeight: label.implicitHeight + popupPadding * 2

    function ansiToRichText(raw) {
        var withSpan = raw.replace(/\x1b\[7m/g, "<span style=\"color:" + Theme.Theme.accent + ";\">").replace(/\x1b\[0m/g, "</span>");
        return "<pre style=\"margin:0;\">" + withSpan + "</pre>";
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        textFormat: Text.RichText
        text: ""
    }

    Process {
        id: calProc
        command: ["cal", "--color=always", "--year"]

        stdout: StdioCollector {
            onStreamFinished: label.text = root.ansiToRichText(this.text)
        }

        Component.onCompleted: running = true
    }
}
