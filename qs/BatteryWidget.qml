import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    property int percentage: 0
    property bool charging: false
    property int warningThreshold: 15
    property string label: ""

    spacing: 4

    readonly property color stateColor: percentage <= warningThreshold ? "red" : "white"

    BatteryIcon {
        level: root.percentage
        charging: root.charging
        color: root.stateColor
    }

    Text {
        text: root.label + root.percentage + "%"
        color: root.stateColor
    }
}
