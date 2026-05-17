import QtQuick

Text {
    id: tempLabel
    property string label: ""
    property int tempC: 0
    property int tempF: 0
    property bool showFahrenheit: false
    property int warningThresholdC: 80
    signal clicked()

    text: label + ": " + (showFahrenheit ? tempF : tempC) + "°" + (showFahrenheit ? "F" : "C")
    color: tempC > warningThresholdC ? "red" : "white"

    MouseArea {
        anchors.fill: parent
        onClicked: tempLabel.clicked()
    }
}
