import QtQuick
import "../common"

SlotText {
    id: root
    property string label: ""
    property string append: ""
    property int value: 0
    property int warningThreshold: 80

    widthSamples: [label + "100" + append]
    content: labelText

    ThresholdText {
        id: labelText
        value: root.value
        warningThreshold: root.warningThreshold
        text: root.label + root.value + root.append
    }
}
