import QtQuick
import "../../theme" as Theme

StyledText {
    id: separator
    property color separatorColor: Theme.Theme.muted
    property string glyph: Theme.Theme.separatorGlyph

    textColor: separatorColor
    text: glyph
}
