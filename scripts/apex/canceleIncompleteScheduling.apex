String cronExp = '0 0 0 * * ?';  // Ejecutar todos los días a la medianoche
String jobName = 'CancelIncompleteScheduling';
ScheduledCancelIncompleteScheduling scheduler = new ScheduledCancelIncompleteScheduling();
System.schedule(jobName, cronExp, scheduler);