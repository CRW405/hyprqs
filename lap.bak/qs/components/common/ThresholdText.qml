import QtQuick
import "../../theme" as Theme

StyledText {
    id: root
    property int value: 0
    property int warningThreshold: 80
    property color warningColor: Theme.Theme.warn

    color: value > warningThreshold ? warningColor : textColor
}
