@isTest
private class TestCancelIncompleteScheduling {

    // Test para asegurarse de que el batch funcione correctamente
    @isTest
    static void testCancelIncompleteScheduling() {
        Appointment__c appointment1 = new Appointment__c(Status__c = 'New');
        // Appointment__c appointment2 = new Appointment__c(Status__c = 'Scheduled');
        Appointment__c appointment3 = new Appointment__c(Status__c = 'Completed'); 
        insert new List<Appointment__c>{appointment1, appointment3};

        List<Appointment__c> appointmentsBefore = [SELECT Id, Status__c FROM Appointment__c];

        System.assertEquals(appointmentsBefore.size(), 2);
        System.assert(appointmentsBefore[0].Status__c == 'New');
        //System.assert(appointmentsBefore[1].Status__c == 'Scheduled');
        System.assert(appointmentsBefore[1].Status__c == 'Completed');

        Test.startTest();
        CancelIncompleteScheduling batch = new CancelIncompleteScheduling();
        Database.executeBatch(batch, 100); 
        Test.stopTest();

        List<Appointment__c> appointmentsAfter = [SELECT Id, Status__c FROM Appointment__c WHERE Id IN :appointmentsBefore];

        for (Appointment__c appointment : appointmentsAfter) {
            if (appointment.Status__c == 'New') {
                System.assertEquals(appointment.Status__c, 'Canceled', 'El estado de la cita debería ser "Canceled".');
            }
        }

        System.assertEquals(appointmentsAfter[1].Status__c, 'Completed', 'El estado de la cita "Completed" no debe cambiar.');
    }
}
