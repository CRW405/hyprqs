pragma Singleton
import QtQuick

QtObject {
    property color bg: "#222222"
    property color fg: "#ffffffcc"
    property color muted: "#ffffff66"
    property color accent: "#ff99c6"
    property color warn: "red"
    property int fontSize: 12
    property string fontFamily: "monospace" // | "mononoki" | "Hack" | "Fira Mono" | "JetBrains Mono"
    property int barHeight: 30
    property int gap: 5
    property int iconSize: 10
    property int radius: 0
    property string separatorGlyph: "|||"
}
