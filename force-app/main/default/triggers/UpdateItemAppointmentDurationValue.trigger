trigger UpdateItemAppointmentDurationValue on Appointment_Item__c (before insert) {
    
    // create a map to store the procedure Ids
    // trigger.new is a list of records that are being inserted
    Map<Id, Product2> procedureMap = new Map<Id, Product2>();
    
    for (Appointment_Item__c item : Trigger.new) {
        if (item.Procedure__c != null) {
            procedureMap.put(item.Procedure__c, null);
        }
    }
    
    List<Product2> procedures = [
        SELECT Id, Duration__c, Cost__c
        FROM Product2
        WHERE Id IN :procedureMap.keySet()
    ];
    
    for (Product2 procedure : procedures) {
        procedureMap.put(procedure.Id, procedure);
    }
    
    for (Appointment_Item__c item : Trigger.new) {
        if (item.Procedure__c != null && procedureMap.containsKey(item.Procedure__c)) {
            Product2 procedure = procedureMap.get(item.Procedure__c);
            item.Duration__c = procedure.Duration__c;
            item.Value__c = procedure.Cost__c;
        }
    }
}