public class AppointmentSummaryPDFController {
    public Appointment__c appointment { get; private set; }

    public AppointmentSummaryPDFController() {
        try {
            String appointmentId = ApexPages.currentPage().getParameters().get('id');

            if (String.isEmpty(appointmentId)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ID de cita no proporcionado.'));
                return;
            }

            appointment = [
                SELECT Name, Client__r.Name, Status__c, Scheduling_Date__c, Total_Duration__c, Total_Value__c
                FROM Appointment__c
                WHERE Id = :appointmentId
                LIMIT 1
            ];
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ocurrió un error: ' + e.getMessage()));
        }
    }
}
