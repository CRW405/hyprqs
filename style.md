# Styling Guide (QML + Quickshell)

QML styling is property-driven (colors, sizes, borders, radius, fonts), not CSS. Think of each QML type as a styled widget with its own properties. You can compose visuals with `Rectangle`, `Text`, `Item`, and layout types (`RowLayout`, `ColumnLayout`) and wire up hover/press states with `MouseArea`.

This repo’s bar is defined in `qs/basicBar.qml`, and widgets live under `qs/components/` (labels, icons, widgets, common). Styling is mostly done by editing those files’ properties or the shared theme.

## Where to style in this repo

| File | What to style |
|---|---|
| `qs/basicBar.qml` | Bar background (`PanelWindow.color`), height (`barHeight`), spacing/margins. |
| `qs/theme/Theme.qml` | Global colors, font size, gaps, icon size, separator glyph. |
| `qs/components/common/Seperator.qml` | Separator glyph, size, and color. |
| `qs/components/widgets/WorkspaceSwitcher.qml` | Workspace chip size, active/inactive colors, icon sizes, spacing. |
| `qs/components/widgets/CavaBars.qml` | Bar color, background, spacing, radius. |
| `qs/components/labels/*Label.qml` | Text color, font, warning thresholds. |
| `qs/components/icons/*Icon.qml` | Icon size, border, fill, and color. |

## Styling primitives (QML “CSS equivalents”)

| QML type | Common styling properties |
|---|---|
| `Rectangle` | `color`, `radius`, `border.width`, `border.color`, `opacity`, `gradient`. |
| `Text` | `color`, `font.pixelSize`, `font.family`, `font.bold`, `opacity`, `elide`. |
| `Image` / `IconImage` | `source`, `width`, `height`, `opacity`, `fillMode`, `sourceSize`. |
| `Item` | `width`, `height`, `implicitWidth`, `implicitHeight`, `opacity`. |
| `RowLayout` / `ColumnLayout` | `spacing`, `Layout.alignment`, `Layout.margins`. |

## Theme pattern (recommended)

Create a central theme object and pass values into components instead of hardcoding. This repo uses `qs/theme/Theme.qml` as the single source of truth.

```qml
// qs/theme/Theme.qml (example)
pragma Singleton
import QtQuick

QtObject {
    property color bg: "#1e1e2e"
    property color fg: "#f8f8f2"
    property color accent: "#89b4fa"
    property color warn: "#f38ba8"
    property int fontSize: 12
    property int barHeight: 26
    property int gap: 6
    property int radius: 6
}
```

Then in `basicBar.qml`:

```qml
import "theme" as Theme

PanelWindow {
    color: Theme.Theme.bg
    implicitHeight: Theme.Theme.barHeight
}
```

## Layout and spacing

Use `RowLayout.spacing` for horizontal gaps, and add padding via `anchors.margins` or wrap content in a `Rectangle` with `anchors.margins`.

```qml
RowLayout {
    anchors.fill: parent
    spacing: 8
}
```

## Interactions (hover, press, toggles)

Use `MouseArea` to change colors on hover/press. This is the QML equivalent of `:hover`/`:active`:

```qml
Rectangle {
    id: chip
    color: hovered ? "#313244" : "#1e1e2e"
    radius: 4

    property bool hovered: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: chip.hovered = true
        onExited: chip.hovered = false
    }
}
```

For smoother transitions:

```qml
Behavior on color { ColorAnimation { duration: 120 } }
```

## Quick examples you can apply now

### Rounded bar with padding
```qml
PanelWindow {
    color: "#11111b"
    implicitHeight: 28

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 8
    }
}
```

### Separator as a dot instead of a pipe
```qml
Text {
    text: "•"
    color: "#6c7086"
    font.pixelSize: 12
}
```

### Active workspace chip background
```qml
Rectangle {
    radius: 4
    color: workspaceItem.isActive ? "#89b4fa" : "transparent"
    border.width: 1
    border.color: "#45475a"
}
```

### Consistent text styling in a label
```qml
Text {
    color: "#cdd6f4"
    font.pixelSize: 12
    font.family: "JetBrains Mono"
}
```

## Quickshell-specific notes

* `PanelWindow` is the bar container. Its `color`, `opacity`, and `implicitHeight` define the bar’s look.
* Most widgets are regular QML items; you can style them exactly like any other QML component.
* Keep `implicitWidth`/`implicitHeight` accurate to avoid layout jitter.
