import QtQuick
import "../common"

ThresholdText {
    id: root
    property string label: ""
    property string append: ""

    warningThreshold: 80
    text: label + value + append
}
