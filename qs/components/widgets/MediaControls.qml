import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../common"
import "../../theme" as Theme

Item {
    id: root

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    RowLayout {
        id: content

        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.Theme.gap

        MediaWidget {
        }

        CavaBars {
        }

    }

    Process {
        id: mediaProc
    }

    Process {
        id: volumeProc
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton)
                mediaProc.command = ["playerctl", "previous"];
            else if (mouse.button === Qt.MiddleButton)
                mediaProc.command = ["playerctl", "play-pause"];
            else if (mouse.button === Qt.RightButton)
                mediaProc.command = ["playerctl", "next"];
            else
                return ;
            mediaProc.running = true;
        }
        onWheel: (wheel) => {
            volumeProc.command = wheel.angleDelta.y > 0 ? ["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "1%+"] : ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%-"];
            volumeProc.running = true;
        }
    }

}
