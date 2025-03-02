public with sharing class AppointmentController {
    @AuraEnabled(cacheable=true)
    public static AppointmentSummary getAppointmentDetails(Id appointmentId) {
        AppointmentSummary result = new AppointmentSummary();

        Appointment__c reservation = [
            SELECT Scheduling_Date__c, Total_Value__c, Total_Duration__c, Status__c
            FROM Appointment__c 
            WHERE Id = :appointmentId 
            LIMIT 1
        ];
        
        result.reservationDate = reservation.Scheduling_Date__c;
        result.totalValue = reservation.Total_Value__c;
        result.totalDuration = reservation.Total_Duration__c;
        result.appointmentStatus = reservation.Status__c;

        List<Appointment_Item__c> items = [
            SELECT Procedure__r.Name, Professional__r.Name, Value__c 
            FROM Appointment_Item__c 
            WHERE Schedule__r.Id = :appointmentId
        ];

        result.procedures = new List<ProcedureDetails>();

        for (Appointment_Item__c item : items) {
            ProcedureDetails procedure = new ProcedureDetails();
            procedure.name = item.Procedure__r.Name;
            procedure.professionalName = item.Professional__r.Name;
            procedure.value = item.Value__c;
            result.procedures.add(procedure);
        }

        return result;
    }

    // Class of storage answer
    public class AppointmentSummary {
        @AuraEnabled public Date reservationDate;
        @AuraEnabled public Decimal totalValue;
        @AuraEnabled public Decimal totalDuration;
        @AuraEnabled public List<ProcedureDetails> procedures;
        @AuraEnabled public String appointmentStatus;
    }

    // Class of details procedure
    public class ProcedureDetails {
        @AuraEnabled public String name;
        @AuraEnabled public String professionalName;
        @AuraEnabled public Decimal value;
    }
}