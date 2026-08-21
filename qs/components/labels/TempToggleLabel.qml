import QtQuick
import "../common"

SlotText {
    id: root
    property string label: ""
    property int tempC: 0
    property int tempF: 0
    property bool showFahrenheit: false
    property int warningThresholdC: 80
    signal clicked()

    widthSamples: [label + "100°F", label + "-100°C"]
    content: labelText

    ThresholdText {
        id: labelText
        value: root.tempC
        warningThreshold: root.warningThresholdC
        text: root.label + (root.showFahrenheit ? root.tempF : root.tempC) + "°" + (root.showFahrenheit ? "F" : "C")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
