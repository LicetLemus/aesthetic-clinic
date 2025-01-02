@isTest
public class TestUpdateItemAppointmentDurationValue {

    @isTest
    public static void testAppointmentItemTrigger() {
        // Paso 1: Crear Producto2 (Procedimiento) con IsActive = false (En proceso de aprobación)
        Product2 testProcedure = new Product2(
            Name = 'Procedimiento A',
            Duration__c = 60,
            Cost__c = 100,
            IsActive = false  // Inicialmente no activo, lo que lo coloca en el flujo de aprobación
        );
        insert testProcedure;
        
        // Paso 2: Crear Appointment_Item__c de prueba con el procedimiento pendiente de aprobación
        Appointment_Item__c testItem = new Appointment_Item__c(
            Procedure__c = testProcedure.Id,
            Status__c = 'New'  // Usa un valor válido para el estado
        );

        // Paso 3: Ejecutar el flujo para simular la aprobación
        Test.startTest();
        // Llamamos al proceso de aprobación aquí, esto simula que el flujo ha actualizado el producto
        // Esto debe realizarse fuera del contexto de la prueba unitaria en la lógica real.
        // Debido a la limitación de las pruebas unitarias, asumiendo que el producto ya está aprobado:

        // Actualizamos el producto a IsActive = true como si el proceso de aprobación hubiera sido ejecutado
        testProcedure.IsActive = true;
        update testProcedure;

        insert testItem;
        Test.stopTest();

        // Paso 4: Verificar los valores
        Appointment_Item__c insertedItem = [SELECT Duration__c, Value__c FROM Appointment_Item__c WHERE Id = :testItem.Id];
        System.assertEquals(60, insertedItem.Duration__c, 'La duración debe ser 60 minutos');
        System.assertEquals(100, insertedItem.Value__c, 'El valor debe ser 100');
    }
}
