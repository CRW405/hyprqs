import QtQuick

Item {
    id: root
    property var values: []
    property int maxValue: 100
    property int barWidth: 3
    property int barHeight: 14
    property int spacing: 2
    property color color: "white"

    implicitWidth: values.length > 0 ? (values.length * barWidth + Math.max(0, values.length - 1) * spacing) : 0
    implicitHeight: barHeight
    width: implicitWidth
    height: implicitHeight

    Row {
        anchors.bottom: parent.bottom
        spacing: root.spacing

        Repeater {
            model: root.values

            Item {
                width: root.barWidth
                height: root.barHeight

                Rectangle {
                    width: parent.width
                    height: Math.max(1, Math.round((modelData / root.maxValue) * root.barHeight))
                    anchors.bottom: parent.bottom
                    color: root.color
                }
            }
        }
    }
}
