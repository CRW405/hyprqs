import QtQuick
import "../common"

ThresholdText {
    id: root
    property string usedStorage: ""
    property string totalStorage: ""
    property int percentage: 0
    property string label: ""

    value: percentage
    warningThreshold: 90
    text: (usedStorage && totalStorage) ? label + usedStorage + "/" + totalStorage + " (" + percentage + "%)" : label + percentage + "%"
}
