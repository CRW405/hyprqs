import QtQuick

Text {
    property string usedStorage: ""
    property string totalStorage: ""
    property int percentage: 0
    property int warningThreshold: 90

    text: "Disk: " + usedStorage + " / " + totalStorage + " (" + percentage + "%)"
    color: percentage > warningThreshold ? "red" : "white"
}
