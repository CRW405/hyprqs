import QtQuick
import QtQuick.Layouts

// Fixed-width wrapper: reserves horizontal space for the widest of
// `widthSamples` and centers `content` within it, so dynamic-width labels
// (percentages, temps, clock, battery status) don't shift neighboring
// RowLayout siblings as their rendered text length changes.
// widthSamples: [] (default) => no reservation, sizes to content's natural width.
//
// `content` must be explicitly bound to the id of the Text-derived child to
// measure/center. SlotText intentionally does NOT redeclare Item's default
// property, so MouseArea/Timer/etc. can be declared as ordinary siblings of
// `content` without being swallowed by a single-object default property.
Item {
    id: root

    property Text content: null
    property var widthSamples: []

    FontMetrics {
        id: metrics
        font: root.content ? root.content.font : Qt.font({})
    }

    function slotWidth() {
        var max = 0
        for (var i = 0; i < widthSamples.length; i++) {
            max = Math.max(max, metrics.advanceWidth(widthSamples[i]))
        }
        return Math.ceil(max)
    }

    implicitWidth: widthSamples.length > 0 ? slotWidth() : (content ? content.implicitWidth : 0)
    implicitHeight: content ? content.implicitHeight : 0
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    onContentChanged: {
        if (!content)
            return

        content.anchors.centerIn = root
        content.horizontalAlignment = Text.AlignHCenter
    }
}
