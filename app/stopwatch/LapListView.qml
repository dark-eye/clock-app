/*
 * Copyright (C) 2015-2016 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import Stopwatch 1.0

ListView {
    id: lapListView

    clip: true
    pressDelay:66

    StopwatchFormatTime {
        id: stopwatchFormatTime
    }

    // HACK : This is an hack to reduce the cases the swiping left/right on a lap might switch between the main view pages
    //        (This a QT issue when you have nested interactive listviews)
    MouseArea {
        height: parent.height
        width: parent.width
        anchors {
            top:parent.top
            left: parent.left
            right: parent.right
        }
        hoverEnabled:true
        propagateComposedEvents: true
        onPressed: { listview.interactive = (count == 0) ; mouse.accepted = false }
        onEntered: listview.interactive = (count == 0)
        onExited: listview.interactive = true
        onReleased: { listview.interactive = true ; mouse.accepted = false }
    }

    header: ListItem {
        visible: count !== 0
        width: parent.width - units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: units.gu(1)
            }

            Label {
                // #TRANSLATORS: This refers to the stopwatch lap and is shown as a header where space is limited. Constrain
                // translation length to a few characters.
                text: i18n.tr("Lap")
                width: parent.width / 5
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
            }

            Label {
                width: 2 * parent.width / 5
                elide: Text.ElideRight
                text: i18n.tr("Lap Time")
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                width: 2 * parent.width / 5
                elide: Text.ElideRight
                text: i18n.tr("Total Time")
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    displaced: Transition {
        UbuntuNumberAnimation {
            property: "y"
            duration: UbuntuAnimation.BriskDuration
        }
    }

    delegate: LapsListDelegate {
        id: lapsListItem
        objectName: "lapsListItem" + index

        divider.anchors.leftMargin: units.gu(2)
        divider.anchors.rightMargin: units.gu(2)

        leadingActions: ListItemActions {
            actions: [
                Action {
                    id: swipeDeleteAction
                    objectName: "swipeDeleteAction"
                    iconName: "delete"
                    onTriggered: {
                        stopwatchEngine.removeLap(index)
                    }
                }
            ]
        }

        indexLabel: "#%1".arg(Number(count - index).toLocaleString(Qt.locale(), "f", 0))
        lapTimeLabel: stopwatchFormatTime.lapTimeToString(model.laptime) + "."
        lapMilliTimeLabel: stopwatchFormatTime.millisToString(model.laptime)
        totalTimeLabel: stopwatchFormatTime.lapTimeToString(model.totaltime) + "."
        totalMilliTimeLabel: stopwatchFormatTime.millisToString(model.totaltime)
    }
}
