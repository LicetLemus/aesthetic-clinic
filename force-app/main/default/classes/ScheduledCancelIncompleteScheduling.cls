public class ScheduledCancelIncompleteScheduling implements Schedulable {

    public void execute(SchedulableContext SC) {
        CancelIncompleteScheduling batch = new CancelIncompleteScheduling();
        Database.executeBatch(batch, 100);
    }
}