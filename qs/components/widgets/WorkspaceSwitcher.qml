import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

// Shows 10 workspace chips: [workspace number] [icon] [icon] ...
RowLayout {
    id: root
    property int fontSize: Theme.Theme.fontSize
    property color textColor: Theme.Theme.fg
    property color activeColor: Theme.Theme.accent
    property int iconSize: Theme.Theme.iconSize
    property int chipPaddingX: 4
    property int chipPaddingY: 2
    property int chipSpacing: Theme.Theme.gap
    property int iconSpacing: 4

    spacing: chipSpacing

    // workspaceId -> array of icon file paths
    property var workspaceIcons: ({})

    // iconName -> single absolute icon file path (first match wins)
    property var availableIconPaths: ({})

    // "Libre Wolf" -> "Libre-Wolf" (desktop icon names usually have no spaces)
    function normalizeIconName(name) {
        if (!name) return ""
        return name.toString().trim().replace(/\s+/g, "-")
    }

    // Parses "<icon-name>\t<path>" lines. Direct file paths instead of
    // image://icon/ theme lookup, which can silently show a placeholder.
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

    // Tries class -> initialClass -> initialTitle -> title; for dotted ids
    // like "org.librewolf.Librewolf" tries the last segment before the full id.
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

    // Rebuilds workspaceIcons from hyprctl clients JSON, deduped per workspace
    // (5 LibreWolf windows on one workspace render as 1 icon).
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

            if (nextIcons[workspaceId].indexOf(icon) === -1)
                nextIcons[workspaceId].push(icon)
        }

        root.workspaceIcons = nextIcons
    }

    // Builds icon-name -> path index from common icon dirs (cached 24h),
    // tab-delimited output for refreshAvailableIcons().
    Process {
        id: iconIndexProc
        command: [
            "sh",
            "-c",
            "cache=\"$HOME/.cache/hyprqs/icon-index.tsv\"; "
                + "cache_dir=\"${cache%/*}\"; "
                + "max_age=86400; "
                + "mkdir -p \"$cache_dir\"; "
                + "now=$(date +%s); "
                + "if [ -f \"$cache\" ]; then "
                + "  mtime=$(stat -c %Y \"$cache\" 2>/dev/null || echo 0); "
                + "else "
                + "  mtime=0; "
                + "fi; "
                + "if [ $((now - mtime)) -lt $max_age ]; then "
                + "  cat \"$cache\"; "
                + "else "
                + "  find /usr/share/icons /usr/share/pixmaps ~/.local/share/icons ~/.icons "
                + "    -type f \\( -name '*.png' -o -name '*.svg' -o -name '*.xpm' \\) "
                + "    -printf '%f\\t%p\\n' 2>/dev/null | awk -F '\\t' '"
                + "    {name=$1; sub(/\\.[^.]*$/, \"\", name); lname=tolower(name); if (!(lname in seen)) {seen[lname]=1; print lname \"\\t\" $2}}' "
                + "    | tee \"$cache\"; "
                + "fi"
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

        // Clickable chip: number + icons; MouseArea covers the whole chip.
        Item {
            id: workspaceItem
            property int workspaceId: index + 1
            property bool isActive: Hyprland.focusedWorkspace?.id === workspaceId

            implicitWidth: contentRow.implicitWidth + (root.chipPaddingX * 2)
            implicitHeight: contentRow.implicitHeight + (root.chipPaddingY * 2)

            Row {
                id: contentRow
                x: root.chipPaddingX
                anchors.verticalCenter: parent.verticalCenter
                spacing: root.iconSpacing

                StyledText {
                    text: workspaceItem.workspaceId
                    textColor: workspaceItem.isActive ? root.activeColor : root.textColor
                    fontSize: root.fontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                Repeater {
                    model: root.iconsForWorkspace(workspaceItem.workspaceId)

                    Item {
                        width: root.iconSize
                        height: root.iconSize
                        anchors.verticalCenter: parent.verticalCenter

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
                onClicked: Hyprland.dispatch(`hl.dsp.focus({workspace = ${workspaceItem.workspaceId}})`)
            }
        }
    }
}
