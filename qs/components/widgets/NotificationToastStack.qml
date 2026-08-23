import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

ColumnLayout {
    id: root

    property int autoHideMs: 5000
    readonly property int count: toasts.count

    spacing: Theme.Theme.gap

    function show(notification) {
        toasts.append({
            notifId: notification.id,
            summary: notification.summary,
            body: notification.body
        });
    }

    function dismiss(notifId) {
        for (let i = 0; i < toasts.count; i++) {
            if (toasts.get(i).notifId === notifId) {
                toasts.remove(i);
                return;
            }
        }
    }

    ListModel {
        id: toasts
    }

    Repeater {
        model: toasts

        delegate: Rectangle {
            id: toastCard
            required property int notifId
            required property string summary
            required property string body

            Layout.preferredWidth: 320
            Layout.preferredHeight: content.implicitHeight + Theme.Theme.gap * 2
            color: Theme.Theme.bg
            border.color: Theme.Theme.muted
            border.width: 1

            ColumnLayout {
                id: content
                anchors.fill: parent
                anchors.margins: Theme.Theme.gap
                spacing: 2

                StyledText {
                    Layout.fillWidth: true
                    text: toastCard.summary
                    textColor: Theme.Theme.fg
                }

                StyledText {
                    Layout.fillWidth: true
                    text: toastCard.body
                    textColor: Theme.Theme.muted
                    wrapMode: Text.WordWrap
                }
            }

            Timer {
                interval: root.autoHideMs
                running: true
                onTriggered: root.dismiss(toastCard.notifId)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.dismiss(toastCard.notifId)
            }
        }
    }
}
