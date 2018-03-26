WorkerScript.onMessage = function(message) {
    // ... long-running operations and calculations are done here
   var result = _activeTimersWorker[message['function']](message['data'])
    WorkerScript.sendMessage({ 'reply': result });
} 

var _activeTimersWorker = {
    getAllAlarmTimers: function (data) {
        var alarmModel =  data.alarmModel;
        if(!alarmModel ) { return null; }

        var alarms = [];
        var timers = [];

        //Remove all active timers that were saved in the DB and exist in the alarm model.
        for(var i=0; i < alarms.length; i++) {
            var timerEntry = this.findTimerAlarmByMessage(alarms[i].message);
            if(timerEntry) {
                alarms.push(alarmModel.get(i));
                i--;
            }
        }

        return { "alarms" : alarms, "action" : data.action };
    },

    /**
    * Find an alarm in the active timers DB by compereing its message.
    */
   findTimerAlarmByMessage: function (alarmMessageToFind,data) {

        if(data.dbActiveTimers && alarmMessageToFind ){
            for(var i in data.dbActiveTimers) {
                if( alarmMessageToFind === data.dbActiveTimers[i].message ) {
                    return data.dbActiveTimers[i];
                }
            }
        }
        return null;
    }
}
