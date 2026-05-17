import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// WorkspaceSwitcher shows 10 workspace "chips":
// [workspace number] [icon] [icon] ...
//
// High-level flow:
// 1) Build an index of real icon files from disk (icon name -> file path).
// 2) Poll Hyprland clients as JSON.
// 3) For each window, find its workspace + matching icon path.
// 4) Render all icons for each workspace (including duplicates per window).
RowLayout {
    id: root
    spacing: 8

    // Map: workspaceId -> array of icon file paths.
    // Example: { 1: ["/usr/share/icons/.../librewolf.svg", "..."], 2: [...] }
    property var workspaceIcons: ({})

    // Map: iconName -> absolute icon file path.
    // We keep only one path per icon name to avoid huge duplicates.
    property var availableIconPaths: ({})

    // Make app names icon-friendly:
    // "Libre Wolf" -> "Libre-Wolf"
    // Rationale: desktop icon names usually do not contain spaces.
    function normalizeIconName(name) {
        if (!name) return ""
        return name.toString().trim().replace(/\s+/g, "-")
    }

    // Parse icon index process output into availableIconPaths.
    // Input format per line: "<icon-name>\t<absolute-file-path>"
    //
    // Why this exists:
    // Theme lookup ("image://icon/...") can show missing-texture placeholders.
    // Using direct file paths lets us skip unresolved icons entirely.
    function refreshAvailableIcons(rawData) {
        if (!rawData) return

        var nextIconPaths = {}
        var lines = rawData.split("\n")
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (!line) continue

            var parts = line.split("\t")
            if (parts.length < 2) continue

            var iconName = parts[0].trim().toLowerCase()
            var iconPath = parts[1].trim()
            if (iconName && iconPath && !nextIconPaths[iconName]) {
                nextIconPaths[iconName] = iconPath
            }
        }

        root.availableIconPaths = nextIconPaths
    }

    // Pick the best icon file path for one Hyprland client/window.
    //
    // We try class-like fields first because they are usually stable:
    // class -> initialClass -> initialTitle -> title
    //
    // For dotted app IDs like "org.librewolf.Librewolf":
    // - try "librewolf" first (last segment)
    // - then try full id
    //
    // Returns:
    // - absolute icon file path string if found
    // - null if no icon is known (we then skip rendering)
    function iconForClient(client) {
        var rawName = client.class || client.initialClass || client.initialTitle || client.title
        var normalized = normalizeIconName(rawName).toLowerCase()
        if (!normalized) return null

        var candidates = [normalized]
        if (normalized.indexOf(".") !== -1) {
            candidates.unshift(normalized.split(".").pop())
        }

        for (var i = 0; i < candidates.length; i++) {
            var candidate = candidates[i]
            if (root.availableIconPaths[candidate]) return root.availableIconPaths[candidate]
        }

        return null
    }

    // Safe getter for the workspace icon array used by the UI repeater.
    function iconsForWorkspace(workspaceId) {
        return root.workspaceIcons[workspaceId] || []
    }

    // Parse hyprctl clients JSON and rebuild workspaceIcons from scratch.
    //
    // Important behavior:
    // We DO NOT dedupe icons here. One window = one icon entry.
    // That means 5 LibreWolf windows render as 5 LibreWolf icons.
    function refreshWorkspaceIcons(rawData) {
        if (!rawData) return

        var parsed
        try {
            parsed = JSON.parse(rawData)
        } catch (e) {
            return
        }

        var nextIcons = {}
        for (var i = 0; i < parsed.length; i++) {
            var client = parsed[i]
            var workspaceId = client.workspace ? client.workspace.id : null
            if (workspaceId === null || workspaceId <= 0) continue

            if (!nextIcons[workspaceId]) nextIcons[workspaceId] = []

            var icon = iconForClient(client)
            if (!icon) continue

            nextIcons[workspaceId].push(icon)
        }

        root.workspaceIcons = nextIcons
    }

    // Process 1: build icon-name -> path index from common icon directories.
    //
    // `find` lists files, awk:
    // - strips file extension
    // - lowercases the icon name
    // - keeps only first path for each icon name
    //
    // Output is tab-delimited lines consumed by refreshAvailableIcons().
    Process {
        id: iconIndexProc
        command: [
            "sh",
            "-c",
            "find /usr/share/icons /usr/share/pixmaps ~/.local/share/icons ~/.icons "
                + "-type f \\( -name '*.png' -o -name '*.svg' -o -name '*.xpm' \\) "
                + "-printf '%f\\t%p\\n' 2>/dev/null | awk -F '\\t' '"
                + "{name=$1; sub(/\\.[^.]*$/, \"\", name); lname=tolower(name); if (!(lname in seen)) {seen[lname]=1; print lname \"\\t\" $2}}'"
        ]

        stdout: StdioCollector {
            onStreamFinished: root.refreshAvailableIcons(this.text)
        }
    }

    // Process 2: fetch live window list from Hyprland as JSON.
    Process {
        id: clientsProc
        command: ["hyprctl", "-j", "clients"]

        stdout: StdioCollector {
            onStreamFinished: root.refreshWorkspaceIcons(this.text)
        }
    }

    // Refresh client/workspace window state frequently so icons feel live.
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: if (!clientsProc.running) clientsProc.running = true
    }

    // Rebuild icon index less often (icon files rarely change while running).
    Timer {
        interval: 120000
        running: true
        repeat: true
        onTriggered: if (!iconIndexProc.running) iconIndexProc.running = true
    }

    // Initial load: index icons and fetch clients immediately.
    Component.onCompleted: {
        iconIndexProc.running = true
        clientsProc.running = true
    }

    // Render fixed workspaces 1..10.
    Repeater {
        model: 10

        // One clickable workspace "chip" that contains number + all icons.
        // MouseArea fills the whole chip, not just the text.
        Item {
            id: workspaceItem
            property int workspaceId: index + 1
            property bool isActive: Hyprland.focusedWorkspace?.id === workspaceId

            implicitWidth: contentRow.implicitWidth + 8
            implicitHeight: contentRow.implicitHeight + 4

            Row {
                id: contentRow
                x: 4
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Text {
                    text: workspaceItem.workspaceId
                    color: workspaceItem.isActive ? "red" : "white"
                }

                Repeater {
                    model: root.iconsForWorkspace(workspaceItem.workspaceId)

                    Item {
                        width: 14
                        height: 14

                        IconImage {
                            anchors.fill: parent
                            // modelData is already an absolute path.
                            source: "file://" + modelData
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + workspaceItem.workspaceId)
            }
        }
    }
}
