import QtQuick

Text {
    property string usedStorage: ""
    property string totalStorage: ""
    property int percentage: 0
    property int warningThreshold: 90
    property string label: ""

    text: (usedStorage && totalStorage) ? label + usedStorage + "/" + totalStorage + " (" + percentage + "%)" : label + percentage + "%"
    color: percentage > warningThreshold ? "red" : "white"
}
