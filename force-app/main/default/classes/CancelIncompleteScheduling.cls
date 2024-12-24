public class CancelIncompleteScheduling implements Database.Batchable<sObject> {


    public Iterable<Appointment__c> start(Database.BatchableContext context) {
        return [SELECT Id, Status__c FROM Appointment__c WHERE Status__c IN ('New', 'Scheduled')];
    }

    public void execute(Database.BatchableContext context, List<Appointment__c> scope) {
        List<Appointment__c> appointments = new List<Appointment__c>();
        for (Appointment__c appointment : scope) {
            appointment.Status__c = 'Canceled';
            appointments.add(appointment);
        }
        update appointments;
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Proceso de cancelación de tareas completado');
    }
}