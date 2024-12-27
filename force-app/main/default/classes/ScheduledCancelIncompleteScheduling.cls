public class ScheduledCancelIncompleteScheduling implements Schedulable {

    public void execute(SchedulableContext SC) {
        // Execute the batch job
        CancelIncompleteScheduling batch = new CancelIncompleteScheduling();
        Database.executeBatch(batch, 100);  // 100 size batch
    }
}