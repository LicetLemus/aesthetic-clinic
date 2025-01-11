@isTest
private class TestAppointmentSummaryPDFController {

    @isTest
    static void testAppointmentSummaryPDFController_ValidAppointment() {

        Appointment__c testAppointment = new Appointment__c(
            Scheduling_Date__c = Date.today(),
            Status__c = 'New'
        );
        insert testAppointment;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', testAppointment.Id);
        AppointmentSummaryPDFController controller = new AppointmentSummaryPDFController();

        System.assertNotEquals(controller.appointment, null, 'La cita no debe ser nula.');
        System.assertEquals(controller.appointment.Id, testAppointment.Id, 'El ID de la cita debe coincidir con el ID proporcionado.');
        System.assertEquals(controller.appointment.Status__c, 'New', 'El estado de la cita debe ser "Scheduled".');
        Test.stopTest();
    }
    
    // Test cuando no se pasa un ID válido (ID vacío)
    @isTest
    static void testAppointmentSummaryPDFController_NoId() {
        // No se establece el parámetro 'id' en la página
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', '');

        // Ejecuta el controlador
        AppointmentSummaryPDFController controller = new AppointmentSummaryPDFController();

        // Verifica que se haya agregado un mensaje de error
        System.assertEquals(ApexPages.getMessages().size(), 1, 'Debe haber un mensaje de error.');
        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'ID de cita no proporcionado.', 'El mensaje de error debe ser el esperado.');
        Test.stopTest();
    }
    
    // Test para manejar excepciones (por ejemplo, problemas con la consulta SOQL)
    @isTest
    static void testAppointmentSummaryPDFController_Exception() {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', '0000000000000001');
        
        // Ejecuta el controlador
        AppointmentSummaryPDFController controller = new AppointmentSummaryPDFController();
        
        // Verifica que se haya agregado un mensaje de error
        System.assertEquals(ApexPages.getMessages().size(), 1, 'Debe haber un mensaje de error.');
        System.assert(ApexPages.getMessages()[0].getSummary().contains('Ocurrió un error'), 'El mensaje de error debe contener "Ocurrió un error".');
        Test.stopTest();
    }
}
