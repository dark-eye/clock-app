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
import U1db 1.0 as U1db

Item {
    id: _activeTimers

    readonly property string  timerPrefix : "(Timer)";

    property AlarmModel alarmModel: null

    // U1db Query to create a model of the world cities saved by the user

    U1db.Index {
        id: active_timers_index
        database: clockDB
        expression: [
            "active_timers.message",
        ]
    }
    U1db.Query {
        id: dbActiveTimers
        index: active_timers_index
        query: ["*"]
    }

    WorkerScript {
           id: timersWorker
           source: "active_timers_worker.js"
           onMessage:{
               switch(messageObject.reply.action ) {
                 case  "removeAllAlarms":
                        for( var i in messageObject.reply.alarms ) {
                           messageObject.reply.alarms[i].cancel();
                        }
                    break;
               }
           }
       }

    /**
     * Remove all the alarms from the alarms model that were saved in the DB as timers.
     */
    function removeAllTimerAlarms() {
       if(!alarmModel ) { return ; }

       var alarms = [];
       var timers = [];
       for(var i=0; i < alarmModel.count; i++) {
           alarms.push(alarmModel.get(i))
       }
       for(var j in dbActiveTimers.documents) {
          timers = dbActiveTimers.documents[j];
       }
        //Remove all active timers that were saved in the DB and exist in the alarm model.
        timersWorker.sendMessage({"function":"getAllAlarmTimers","data":{"alarmModel": alarms, "dbActiveTimers":timers,"action":"removeAllAlarms"}});

       //Remove all active timers that for somereason were left in the DB.
       for(var j in dbActiveTimers.documents) {
           clockDB.deleteDoc(dbActiveTimers.documents[j]);
       }
    }

    /**
     * Get the count of the timers that were saved in the active timers DB.
     */
    function count() {
        return dbActiveTimers.results.length;
    }
    /**
     * Check if a given alarm is a timer alarm.
     */
    function isAlarmATimerAlarm(alarmToCheck) {
        return alarmToCheck && findTimerAlarmByMessage(alarmToCheck.message) !== null;
    }

    /**
     * Find an alarm in the active timers DB by compereing its message.
     */
    function findTimerAlarmByMessage(alarmMessageToFind) {

        if(dbActiveTimers.results && alarmMessageToFind ){
            for(var i in dbActiveTimers.results) {
                if( alarmMessageToFind === dbActiveTimers.results[i].message ) {
                    return dbActiveTimers.results[i];
                }
            }
        }
        return null;
    }


    /**
     * Get the alarm object from the alarm model that corresponde to a given timer in the DB.
     */
    function findAlarmByTimerAlarm(timerAlarm) {
        if( !alarmModel || !timerAlarm || !timerAlarm.message ) { return null; }

        for(var i=0; i <  alarmModel.count; i++) {
            if( timerAlarm.message === alarmModel.get(i).message ||
                timerAlarm.message.trim() === alarmModel.get(i).message ) {
                return alarmModel.get(i);
            }
        }
    }

    /**
     * Add an active timer to the DB.
     */
    function addActiveTimer(timer) {
        clockDB.putDoc({"active_timers":{"time":timer.date,"message":timer.message}});
    }

    function addPrefixToMessage(message) {
        return  _activeTimers.timerPrefix + (message ? " " + message : "");
    }

}
