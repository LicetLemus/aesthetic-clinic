@isTest
public class TestUpdateAppointmentStatusPending {
    
    @isTest
    static void testUpdateStatusToPendingPayment() {

        Product2 testProcedure = new Product2(
            Name = 'Procedimiento A',
            Duration__c = 60,
            Cost__c = 100,
            IsTestModeForValidation__c = true, 
            IsActive = true
        );
        insert testProcedure;

        // Crear datos de prueba para Appointment__c
        Appointment__c reservation = new Appointment__c(Status__c = 'New');
        insert reservation;
        
        // Crear datos de prueba para Appointment_Item__c
        Appointment_Item__c item1 = new Appointment_Item__c(Schedule__c = reservation.Id, Procedure__c = testProcedure.Id,  Status__c = 'New');
        Appointment_Item__c item2 = new Appointment_Item__c(Schedule__c = reservation.Id, Procedure__c = testProcedure.Id, Status__c = 'New');
        insert new List<Appointment_Item__c>{item1, item2};

        // Actualizar los Appointment_Item__c a 'Completed'
        item1.Status__c = 'Completed';
        item2.Status__c = 'Completed';
        update new List<Appointment_Item__c>{item1, item2};
        
        // Verificar que el estado de la reserva se actualiza a 'Pending Payment'
        Appointment__c updatedReservation = [SELECT Status__c FROM Appointment__c WHERE Id = :reservation.Id];
        System.assertEquals('Pending Payment', updatedReservation.Status__c, 'El estado de la reserva debe ser "Pending Payment"');
    }

    // Test donde no todos los Appointment_Item__c están completos, por lo que no se debe actualizar el estado de la reserva
    @isTest
    static void testNotAllItemsCompleted() {
        // Crear datos de prueba para Appointment__c
        Product2 testProcedure = new Product2(
            Name = 'Procedimiento A',
            Duration__c = 60,
            Cost__c = 100,
            IsTestModeForValidation__c = true, 
            IsActive = true
        );
        insert testProcedure;

        // Crear datos de prueba para Appointment__c
        Appointment__c reservation = new Appointment__c(Status__c = 'New');
        insert reservation;
        
        // Crear datos de prueba para Appointment_Item__c
        Appointment_Item__c item1 = new Appointment_Item__c(Schedule__c = reservation.Id, Procedure__c = testProcedure.Id,  Status__c = 'New');
        Appointment_Item__c item2 = new Appointment_Item__c(Schedule__c = reservation.Id, Procedure__c = testProcedure.Id, Status__c = 'New');
        insert new List<Appointment_Item__c>{item1, item2};

        // Actualizar solo un Appointment_Item__c a 'Completed'
        item1.Status__c = 'Completed';
        update new List<Appointment_Item__c>{item1};

        // Verificar que el estado de la reserva no cambia
        Appointment__c updatedReservation = [SELECT Status__c FROM Appointment__c WHERE Id = :reservation.Id];
        System.assertEquals('New', updatedReservation.Status__c, 'El estado de la reserva no debe cambiar porque no todos los elementos están completos');
    }

    // Test cuando no se actualizan Appointment_Item__c
    @isTest
    static void testNoAppointmentItemsUpdated() {
         // Crear datos de prueba para Appointment__c
        Product2 testProcedure = new Product2(
            Name = 'Procedimiento A',
            Duration__c = 60,
            Cost__c = 100,
            IsTestModeForValidation__c = true, 
            IsActive = true
        );
        insert testProcedure;

        // Crear datos de prueba para Appointment__c
        Appointment__c reservation = new Appointment__c(Status__c = 'New');
        insert reservation;
        
        // Crear datos de prueba para Appointment_Item__c
        Appointment_Item__c item1 = new Appointment_Item__c(Schedule__c = reservation.Id, Procedure__c = testProcedure.Id,  Status__c = 'New');
        Appointment_Item__c item2 = new Appointment_Item__c(Schedule__c = reservation.Id, Procedure__c = testProcedure.Id, Status__c = 'New');
        insert new List<Appointment_Item__c>{item1, item2};

        // No actualizamos nada, solo verificamos que el trigger no ejecute cambios innecesarios
        Test.startTest();
        update new List<Appointment_Item__c>{};
        Test.stopTest();
        
        // Verificar que el estado de la reserva no cambia
        Appointment__c updatedReservation = [SELECT Status__c FROM Appointment__c WHERE Id = :reservation.Id];
        System.assertEquals('New', updatedReservation.Status__c, 'El estado de la reserva no debe cambiar ya que no se ha realizado ninguna actualización en los elementos');
    }
    
}
