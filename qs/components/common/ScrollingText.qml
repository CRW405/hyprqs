import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

// Fixed-width marquee: reserves `maxWidth` and scrolls `text` back and forth
// when it doesn't fit, pausing at each end. Static (no animation) when the
// text fits within maxWidth - mirrors SlotText's "reserve space" philosophy,
// but for content that can be wider than its box rather than narrower.
Item {
    id: root

    property string text: ""
    property color textColor: Theme.Theme.fg
    property int fontSize: Theme.Theme.fontSize
    property string fontFamily: Theme.Theme.fontFamily
    property int maxWidth: 160
    property int pauseDuration: 1500
    property int pixelsPerSecond: 30
    readonly property bool overflowing: label.implicitWidth > root.width

    implicitWidth: maxWidth
    implicitHeight: label.implicitHeight
    Layout.preferredWidth: maxWidth
    Layout.preferredHeight: implicitHeight
    clip: true

    StyledText {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        textColor: root.textColor
        fontSize: root.fontSize
        fontFamily: root.fontFamily
    }

    SequentialAnimation {
        running: root.overflowing
        loops: Animation.Infinite

        PauseAnimation {
            duration: root.pauseDuration
        }

        NumberAnimation {
            target: label
            property: "x"
            from: 0
            to: -(label.implicitWidth - root.width)
            duration: Math.max(500, (label.implicitWidth - root.width) / root.pixelsPerSecond * 1000)
            easing.type: Easing.Linear
        }

        PauseAnimation {
            duration: root.pauseDuration
        }

        NumberAnimation {
            target: label
            property: "x"
            from: -(label.implicitWidth - root.width)
            to: 0
            duration: Math.max(500, (label.implicitWidth - root.width) / root.pixelsPerSecond * 1000)
            easing.type: Easing.Linear
        }
    }

    onTextChanged: label.x = 0
}
