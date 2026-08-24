import QtQuick
import "../common"

ThresholdText {
    id: tempLabel
    property string label: ""
    property int tempC: 0
    property int tempF: 0
    property bool showFahrenheit: false
    property int warningThresholdC: 80
    signal clicked()

    value: tempC
    warningThreshold: warningThresholdC
    text: label + (showFahrenheit ? tempF : tempC) + "°" + (showFahrenheit ? "F" : "C")

    MouseArea {
        anchors.fill: parent
        onClicked: tempLabel.clicked()
    }
}
