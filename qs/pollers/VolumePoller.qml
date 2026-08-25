import Quickshell.Services.Pipewire
import QtQuick

Item {
    id: root

    // Reactive via PwObjectTracker, not polled - stays live for wpctl/media-key changes too.
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: !!sink && sink.ready && !!sink.audio
    readonly property real volume: ready ? sink.audio.volume : 0
    readonly property bool muted: ready ? sink.audio.muted : false
}
