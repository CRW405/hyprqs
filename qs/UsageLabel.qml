import QtQuick

Text {
    property string label: ""
    property int value: 0
    property int warningThreshold: 80
    property string append: ""

    text: label + value + append
    color: value > warningThreshold ? "red" : "white"
}
