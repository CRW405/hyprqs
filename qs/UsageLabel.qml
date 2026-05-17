import QtQuick

Text {
    property string label: ""
    property int value: 0
    property int warningThreshold: 80

    text: label + ": " + value + "%"
    color: value > warningThreshold ? "red" : "white"
}
