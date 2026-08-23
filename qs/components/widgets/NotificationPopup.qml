import QtQuick
import QtQuick.Layouts
import "../common"
import "../../theme" as Theme

Rectangle {
    id: root

    property var notificationServer: null
    readonly property bool hovered: hoverHandler.hovered
    readonly property int popupPadding: Theme.Theme.gap * 3
    readonly property int count: notificationServer ? notificationServer.trackedNotifications.values.length : 0

    color: Theme.Theme.bg
    border.color: Theme.Theme.muted
    border.width: 1
    implicitWidth: 320
    implicitHeight: Math.min(400, list.implicitHeight + popupPadding * 2)

    // HoverHandler (not a hoverEnabled MouseArea) so hover tracking doesn't
    // compete with each notification's own dismiss-button MouseArea for hit-testing.
    HoverHandler {
        id: hoverHandler
    }

    ColumnLayout {
        id: list
        anchors.fill: parent
        anchors.margins: root.popupPadding
        spacing: Theme.Theme.gap

        StyledText {
            visible: root.count === 0
            text: "No notifications"
            textColor: Theme.Theme.muted
        }

        Repeater {
            model: root.notificationServer ? root.notificationServer.trackedNotifications : null

            delegate: RowLayout {
                id: notifRow
                required property var modelData

                Layout.fillWidth: true
                spacing: Theme.Theme.gap

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    StyledText {
                        Layout.fillWidth: true
                        text: notifRow.modelData.summary
                        textColor: Theme.Theme.fg
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: notifRow.modelData.body
                        textColor: Theme.Theme.muted
                        wrapMode: Text.WordWrap
                    }
                }

                StyledText {
                    text: "X"
                    textColor: Theme.Theme.warn

                    MouseArea {
                        anchors.fill: parent
                        onClicked: notifRow.modelData.dismiss()
                    }
                }
            }
        }
    }
}
