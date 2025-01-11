@isTest
public class TestUpdateItemAppointmentDurationValue {

    @isTest
    public static void testProcedureIsValid() {
        // Paso 1: Crear Producto2 (Procedimiento) con IsActive = false (En proceso de aprobación)
        Product2 testProcedure = new Product2(
            Name = 'Procedimiento A',
            Duration__c = 60,
            Cost__c = 100,
            IsTestModeForValidation__c = true, 
            IsActive = true
        );
        insert testProcedure;
        
        Appointment__c reservation = new Appointment__c(
        	Status__c = 'New',
            Scheduling_Date__c = Date.newInstance(2024, 12, 24)
        );
        insert reservation;
        
        Appointment_Item__c testItem = new Appointment_Item__c(
            Schedule__c = reservation.id,
            Procedure__c = testProcedure.Id,
            Status__c = 'New'
        );

        Test.startTest();
        insert testItem;
        Test.stopTest();

        // Paso 4: Verificar los valores
        Appointment_Item__c insertedItem = [SELECT Duration__c, Value__c FROM Appointment_Item__c WHERE Id = :testItem.Id];
        System.assertEquals(60, insertedItem.Duration__c, 'La duración debe ser 60 minutos');
        System.assertEquals(100, insertedItem.Value__c, 'El valor debe ser 100');
    }
    
    
}