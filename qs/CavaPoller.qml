import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: cavaPoller
    property var barValues: []
    property int barsCount: 16
    property int maxValue: 100
    property string configPath: ""

    function initBars() {
        var values = []
        for (var i = 0; i < cavaPoller.barsCount; i++) values.push(0)
        cavaPoller.barValues = values
    }

    function updateBars(rawLine) {
        var line = rawLine ? rawLine.trim() : ""
        if (!line) return

        var matches = line.match(/[0-9]+/g)
        if (!matches || matches.length === 0) return

        var values = []
        for (var i = 0; i < matches.length; i++) {
            var v = parseInt(matches[i])
            if (isNaN(v)) continue
            values.push(Math.min(cavaPoller.maxValue, Math.max(0, v)))
        }

        if (values.length === 0) return

        if (values.length < cavaPoller.barsCount) {
            while (values.length < cavaPoller.barsCount) values.push(0)
        } else if (values.length > cavaPoller.barsCount) {
            values = values.slice(values.length - cavaPoller.barsCount)
        }

        cavaPoller.barValues = values
    }

    Process {
        id: cavaProc
        command: cavaPoller.configPath
            ? ["cava", "-p", cavaPoller.configPath]
            : ["cava"]

        stdout: SplitParser {
            onRead: data => cavaPoller.updateBars(data)
        }

        Component.onCompleted: running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!cavaProc.running) cavaProc.running = true
    }

    Component.onCompleted: cavaPoller.initBars()
    onBarsCountChanged: cavaPoller.initBars()
}
