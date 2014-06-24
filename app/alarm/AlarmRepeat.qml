/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: _alarmRepeatPage

    visible: false
    title: i18n.tr("Repeat")

    // Property to set the alarm days of the week in the edit alarm page
    property var alarm

    ListModel {
        id: daysModel

        ListElement {
            day: "1"
            flag: Alarm.Monday
        }

        ListElement {
            day: "2"
            flag: Alarm.Tuesday
        }

        ListElement {
            day: "3"
            flag: Alarm.Wednesday
        }

        ListElement {
            day: "4"
            flag: Alarm.Thursday
        }

        ListElement {
            day: "5"
            flag: Alarm.Friday
        }

        ListElement {
            day: "6"
            flag: Alarm.Saturday
        }

        ListElement {
            day: "0"
            flag: Alarm.Sunday
        }
    }

    Column {
        id: _alarmDayColumn

        anchors.fill: parent

        Repeater {
            id: _alarmDays

            model: daysModel

            ListItem.Standard {
                Label {
                    id: _alarmDay

                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(2)
                    anchors.verticalCenter: parent.verticalCenter

                    color: UbuntuColors.midAubergine
                    text: Qt.locale().standaloneDayName(day, Locale.LongFormat)
                }

                control: Switch {
                    checked: (alarm.daysOfWeek & flag) == flag
                    onCheckedChanged: {
                        if (checked) {
                            alarm.daysOfWeek |= flag
                        }

                        else {
                            alarm.daysOfWeek &= ~flag
                        }
                    }
                }
            }
        }
    }
}
