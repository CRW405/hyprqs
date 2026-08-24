import Quickshell.Services.Pipewire
import QtQuick

Item {
    id: root

    // Reactive, not polled: PwObjectTracker subscribes to the default sink
    // so `audio` stays live-updated, including changes made by wpctl (from
    // this widget, CavaBars' scroll controls, or hardware media keys).
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: !!sink && sink.ready && !!sink.audio
    readonly property real volume: ready ? sink.audio.volume : 0
    readonly property bool muted: ready ? sink.audio.muted : false
}
