trigger UpdateAppointmentStatusPending on Appointment_Item__c (after update) {

    // Set to store reservation IDs for processing
    Set<Id> reservationIds = new Set<Id>();

    // Collect IDs of reservations associated with updated items
    for (Appointment_Item__c item : Trigger.new) {
        if (item.Status__c == 'Completed' && 
            Trigger.oldMap.get(item.Id).Status__c != 'Completed' &&
            item.Schedule__c != null) {
                reservationIds.add(item.Schedule__c);
        }
    }

    if (!reservationIds.isEmpty()) {
        // Query all items associated with the reservations in one SOQL
        List<Appointment_Item__c> allItems = [
            SELECT Id, Status__c, Schedule__c
            FROM Appointment_Item__c
            WHERE Schedule__c IN :reservationIds
        ];

        // Map to group items by reservation
        Map<Id, List<Appointment_Item__c>> reservationItemsMap = new Map<Id, List<Appointment_Item__c>>();

        // Group items by their associated reservation
        for (Appointment_Item__c item : allItems) {
            if (!reservationItemsMap.containsKey(item.Schedule__c)) {
                reservationItemsMap.put(item.Schedule__c, new List<Appointment_Item__c>());
            }
            reservationItemsMap.get(item.Schedule__c).add(item);
        }

        // Prepare list of reservations to update
        List<Appointment__c> reservationsToUpdate = new List<Appointment__c>();

        // Check if all items in each reservation are completed
        for (Id reservationId : reservationItemsMap.keySet()) {
            Boolean allCompleted = true;
            for (Appointment_Item__c item : reservationItemsMap.get(reservationId)) {
                if (item.Status__c != 'Completed') {
                    allCompleted = false;
                    break;
                }
            }
            if (allCompleted) {
                reservationsToUpdate.add(new Appointment__c(
                    Id = reservationId,
                    Status__c = 'Pending Payment'
                ));
            }
        }

        // Update reservations
        if (!reservationsToUpdate.isEmpty()) {
            try {
                update reservationsToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating reservations: ' + e.getMessage());
            }
        }
    }
}

