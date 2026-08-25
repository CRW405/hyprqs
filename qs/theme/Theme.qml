pragma Singleton
import QtQuick
import "." as Local

// Bar-specific theme: colors/font/radius/gap mirror the shared palette (Palette.qml);
// barHeight/iconSize/separatorGlyph are bar-only and stay local.
QtObject {
    property color bg: Local.Palette.color.background
    property color bgAlt: Local.Palette.color.background_light
    property color fg: Local.Palette.color.text
    property color muted: Local.Palette.color.text_secondary
    property color accent: Local.Palette.color.primary
    property color warn: Local.Palette.color.warning
    property int fontSize: Local.Palette.font.size
    property string fontFamily: Local.Palette.font.family
    property int barHeight: 30
    property int gap: Local.Palette.spacing.gap
    property int iconSize: 10
    property int radius: Local.Palette.radius
    property string separatorGlyph: "|||"
}
