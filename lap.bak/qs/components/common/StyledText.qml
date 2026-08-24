import QtQuick
import "../../theme" as Theme

Text {
    id: root
    property color textColor: Theme.Theme.fg
    property int fontSize: Theme.Theme.fontSize
    property string fontFamily: Theme.Theme.fontFamily

    color: textColor
    font.pixelSize: fontSize
    font.family: fontFamily
}
