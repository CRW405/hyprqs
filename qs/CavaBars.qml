import QtQuick
import Quickshell.Io

Item {
    id: root

    property int bars: 20 // change it in cava.conf too
    property int maxValue: 1000
    property int barWidth: 3
    property int barSpacing: 1
    property int padding: 2
    property color barColor: "white"
    property color backgroundColor: "transparent"
    property var values: []
    readonly property string cavaConfigPath: Qt.resolvedUrl("cava.conf").toString().replace("file://", "")

    implicitWidth: (bars * barWidth) + ((bars - 1) * barSpacing) + padding * 2
    implicitHeight: 18

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: 3
    }

    Row {
        id: barRow

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.padding
        spacing: root.barSpacing

        Repeater {
            model: root.bars

            Rectangle {
                width: root.barWidth
                height: Math.max(1, Math.round(((root.values[index] || 0) / root.maxValue) * (root.height - root.padding * 2)))
                radius: 1
                color: root.barColor
                anchors.bottom: parent.bottom
            }

        }

    }

    Process {
        id: cavaProc

        command: ["cava", "-p", root.cavaConfigPath]
        Component.onCompleted: running = true

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                const parts = data.trim().split(";");
                if (parts.length < root.bars)
                    return ;

                const next = [];
                for (let i = 0; i < root.bars; i++) {
                    const value = parseInt(parts[i], 10);
                    next.push(Number.isFinite(value) ? Math.min(root.maxValue, value) : 0);
                }
                root.values = next;
            }
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (!cavaProc.running)
                cavaProc.running = true;

        }
    }

}
