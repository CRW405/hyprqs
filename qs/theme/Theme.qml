pragma Singleton
import QtQuick
import "." as Local

// Bar-specific theme. Colors/font/radius/gap come from the shared palette
// (Palette.qml -> style/style.json) so the bar stays in sync with
// hyprland.lua and rofi; barHeight/iconSize/separatorGlyph are bar-only
// layout values with no cross-tool equivalent, so they stay local.
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
