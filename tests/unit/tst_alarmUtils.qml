/*
 * Copyright (C) 2014 Canonical Ltd
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

import QtTest 1.0
import Ubuntu.Components 1.1
import "../../app/alarm"

TestCase {
    id: alarmUtilsTest
    name: "AlarmUtilsLibrary"

    AlarmUtils {
        id: alarmUtils
    }

    /*
     This test checks if the _split_time() function takes a time in milliseconds
     and is able to split it into days, hours and minutes correctly.
    */
    function test_splitTime() {
        var timeInMilliseconds = 440100000 // 5 days, 2 hrs, 16 mins
        var result = alarmUtils._split_time(timeInMilliseconds)
        compare(result.days, 5, "Days calculated is incorrect.")
        compare(result.hours, 2, "Hours calculated is incorrect")
        compare(result.minutes, 16, "Minutes calculated is incorrect")
    }

    /*
     This test checks if the get_time_to_next_alarm() function takes a time in
     milliseconds and writtens a user readable string e.g "in 2d 15h 10m" after
     correct calculation.
    */
    function test_timeToNextAlarmStringMustShowAll() {
        var timeInMilliseconds = 440100000; // 5 days, 2 hrs, 16 mins
        var result = alarmUtils.get_time_to_next_alarm(timeInMilliseconds)
        compare(result, "in 5d 2h 16m", "Time to next alarm string is incorrect")
    }

    /*
     This test checks if the get_time_to_next_alarm() function takes a time in
     milliseconds and writtens a user readable string without days e.g "in 15h 10m"
     after correct calculation.
    */
    function test_timeToNextAlarmStringMustNotShowDays() {
        var timeInMilliseconds = 36000000 // 10 hours, 1 min
        var result = alarmUtils.get_time_to_next_alarm(timeInMilliseconds)
        compare(result, "in 10h 1m", "Time to next alarm string is incorrect")
    }

    /*
     This test checks if the get_time_to_next_alarm() function takes a time in
     milliseconds and writtens a user readable string with only mins e.g "in 10m"
     after correct calculation.
    */
    function test_timeToNextAlarmStringMustOnlyShowMinutes() {
        var timeInMilliseconds = 1080000 // 19 mins
        var result = alarmUtils.get_time_to_next_alarm(timeInMilliseconds)
        compare(result, "in 19m", "Time to next alarm string is incorrect")
    }

    /*
     This test checks if the _get_day() function takes in the daysOfWeek value
     and returns the correct alarm day names.
    */
    function test_alarmDayString() {
        var value = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Sunday
        var result = alarmUtils._get_day(value)
        compare(result, "Monday, Tuesday, Wednesday, Sunday", "Alarm Day not properly formatted")
    }

    /*
     This test checks if the format_day_string() returns "Never" if a one-time
     alarm is passed to it for the alarm recurrence string.
    */
    function test_alarmRecurrenceStringMustShowNever() {
        var alarmType = Alarm.OneTime
        var alarmDaysOfWeek = Alarm.AutoDetect
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Never", "OneTime Alarm is shown as a repeating alarm")
    }

    /*
     This test checks if the format_day_string() returns the alarm days if the
     alarms days passed if it doesn't fit other formats like Weekdays, Weekends etc.
    */
    function test_alarmRecurrenceStringMustShowAlarmDays() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Monday, Tuesday", "Repeating alarm days of week is not formatted correctly")
    }

    /*
     This test checks if the format_day_string() returns "Weekdays" if all week days (Mon-Fri)
     of a week are selected.
    */
    function test_alarmRecurrenceStringMustShowWeekdays() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Thursday | Alarm.Friday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Weekdays", "Repeating alarm days of week is not formatted correctly")
    }

    /*
     This test checks if the format_day_string() returns "Weekends" (Sat-Sun) if the
     weekends of a week are selected.
    */
    function test_alarmRecurrenceStringMustShowWeekends() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Saturday | Alarm.Sunday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Weekends", "Repeating alarm days of week is not formatted correctly")
    }

    /*
     This test checks if the format_day_string() returns "Days" if all days
     of a week are selected.
    */
    function test_alarmRecurrenceStringMustShowDaily() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Thursday | Alarm.Friday | Alarm.Saturday | Alarm.Sunday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Daily", "Repeating alarm days of week is not formatted correctly")
    }
}