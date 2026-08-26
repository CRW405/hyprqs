import QtQuick
import QtQuick.Layouts
import "../common"
import "../icons"
import "../../theme" as Theme

RowLayout {
    id: root

    property string profile: "unknown"
    property var availableProfiles: []
    property bool pending: false
    property color textColor: Theme.Theme.fg
    property int fontSize: Theme.Theme.fontSize
    property int iconSize: Theme.Theme.iconSize

    signal profileChangeRequested(string next)

    function nextProfile() {
        var list = root.availableProfiles;
        if (!list || list.length === 0)
            list = ["power-saver", "balanced", "performance"];

        var idx = list.indexOf(root.profile);
        if (idx === -1)
            return list[0];

        return list[(idx + 1) % list.length];
    }

    spacing: Theme.Theme.gap
    opacity: root.pending ? 0.5 : 1

    StyledText {
        text: root.profile
        textColor: root.textColor
        fontSize: root.fontSize
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var next = root.nextProfile();
            if (!next)
                return ;

            root.profileChangeRequested(next);
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 120
        }

    }

}
