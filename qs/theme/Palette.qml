pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Shared style tokens (colors/font/radius/spacing) for hyprland.lua and the rofi menus.
// Reads style/style.json live; defaults below only apply until it loads.
QtObject {
	id: root

	property QtObject color: QtObject {
		property color primary: "#5c9dff"
		property color secondary: "#b39dff"
		property color danger: "#ff6b6b"
		property color warning: "#ffcc00"
		property color ok: "#4caf50"
		property color active: "#45454e"
		property color inactive: "#6a6a72"
		property color background: "#1c1c1e"
		property color background_light: "#3a3a40"
		property color background_dark: "#2a2a2e"
		property color border: "#6e6e78"
		property color border_light: "#5a6b9c"
		property color border_dark: "#241b40"
		property color text: "#d4d4d8"
		property color text_secondary: "#6a6a72"
		property color text_light: "#ffffff"
		property color text_dark: "#1c1c1e"
	}

	property QtObject font: QtObject {
		property string family: "Monospace"
		property int size: 12
	}

	property int radius: 10

	property QtObject spacing: QtObject {
		property int gap: 5
		property int padding: 10
	}

	property FileView _file: FileView {
		// Qt.resolvedUrl resolves against Quickshell's virtual -p root, not this
		// file's real path; Quickshell.shellDir keeps this correct regardless of checkout location.
		path: Quickshell.shellDir + "/../style/style.json"
		watchChanges: true
		onFileChanged: reload()
		onLoaded: {
			try {
				root._apply(JSON.parse(text()))
			} catch (e) {
				console.warn("Palette: failed to parse style/style.json:", e)
			}
		}
		onLoadFailed: error => console.warn("Palette: failed to load style/style.json:", error)
	}

	function _apply(data) {
		if (data.color) {
			for (const key in data.color) {
				if (root.color.hasOwnProperty(key)) {
					root.color[key] = "#" + data.color[key]
				}
			}
		}
		if (data.font) {
			if (data.font.family)
				root.font.family = data.font.family
			if (data.font.size)
				root.font.size = data.font.size
		}
		if (data.radius !== undefined)
			root.radius = data.radius
		if (data.spacing) {
			if (data.spacing.gap !== undefined)
				root.spacing.gap = data.spacing.gap
			if (data.spacing.padding !== undefined)
				root.spacing.padding = data.spacing.padding
		}
	}
}
