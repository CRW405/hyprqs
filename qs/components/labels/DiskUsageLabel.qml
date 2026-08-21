import QtQuick
import "../common"

SlotText {
    id: root
    property string usedStorage: ""
    property string totalStorage: ""
    property int percentage: 0
    property string label: ""

    widthSamples: [(usedStorage && totalStorage) ? (label + totalStorage + "/" + totalStorage + " (100%)") : (label + "100%")]
    content: labelText

    ThresholdText {
        id: labelText
        value: root.percentage
        warningThreshold: 90
        text: (root.usedStorage && root.totalStorage) ? root.label + root.usedStorage + "/" + root.totalStorage + " (" + root.percentage + "%)" : root.label + root.percentage + "%"
    }
}
