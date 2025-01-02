@isTest
public class TestAppointmentController {
    
    @testSetup
    static void setup() {
        
        User professional1 = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        
        // Crear cita de prueba (Appointment)
        Appointment__c appointment = new Appointment__c(
            Scheduling_Date__c = Date.today(),
            Status__c = 'New'
        );
        insert appointment;
        
        // Crear procedimientos de prueba (Product2)
        Product2 procedure1 = new Product2(
            Name = 'Test Procedure 1', 
            IsTestModeForValidation__c = true, 
            IsActive = true
        );
        insert procedure1;
        
        // Crear ítems de cita (Appointment Items)
        Appointment_Item__c item1 = new Appointment_Item__c(
        	Schedule__c = appointment.Id,
        	Procedure__c = procedure1.Id,
        	Professional__c = professional1.Id,
        	Value__c = 50,
        	Duration__c = 20
        );
        insert item1;
        
        // Actualizar la cita para recalcular los campos de resumen
    	appointment = [SELECT Id, Total_Value__c, Total_Duration__c FROM Appointment__c WHERE Id = :appointment.Id];
    	update appointment;
    }
    
    @isTest
    static void testGetAppointmentDetails_Success() {
        // get Id of the appointment created in the setup method
        Appointment__c appointmentId = [SELECT Id FROM Appointment__c LIMIT 1];

        // Call the method to be tested
        Test.startTest();
        AppointmentController.AppointmentSummary result = AppointmentController.getAppointmentDetails(appointmentId.Id);
        Test.stopTest();
        
        // Validate the results
        System.assertNotEquals(result, null, 'Result should not be null');
        System.assertEquals(result.reservationDate, Date.today(), 'The reservation date should match');
        System.assertEquals(result.appointmentStatus, 'New', 'The appointment status should match');
        System.assertEquals(result.procedures[0].name, 'Test Procedure 1', 'The first procedure name should match');
    }
    
    @isTest
    static void testGetAppointmentDetails_NoProcedures() {
        // Create an appointment without related procedures
        Appointment__c appointment = new Appointment__c(
            Scheduling_Date__c = Date.today(),
        	Status__c = 'New'
        );
        insert appointment;
        
        // Call the method to be tested
        Test.startTest();
        AppointmentController.AppointmentSummary result = AppointmentController.getAppointmentDetails(appointment.Id);
        Test.stopTest();
        
        // Validate that no procedures are returned
        System.assertNotEquals(result, null, 'Result should not be null');
        System.assertEquals(result.procedures.size(), 0, 'There should be no procedures');
    }
}