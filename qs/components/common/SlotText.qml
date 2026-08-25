import QtQuick
import QtQuick.Layouts

// Fixed-width wrapper: reserves space for the widest of `widthSamples` and
// centers `content` in it, so dynamic-width labels don't shift RowLayout siblings.
// `content` must bind to the Text child to measure/center; SlotText doesn't
// redeclare Item's default property, so other children aren't swallowed by it.
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
