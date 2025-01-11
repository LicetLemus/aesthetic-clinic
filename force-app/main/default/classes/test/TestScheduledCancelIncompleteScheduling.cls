@isTest
public class TestScheduledCancelIncompleteScheduling {

    public static String CRON_EXP = '0 0 0 15 3 ? 2042';

    @isTest
    static void testScheduledJob() {
        Test.startTest();

        ScheduledCancelIncompleteScheduling schedulableInstance = new ScheduledCancelIncompleteScheduling();
        
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, schedulableInstance);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression, 'La expresión cron debe coincidir');
        System.assertEquals(0, ct.TimesTriggered, 'El trabajo no debería haberse ejecutado aún');
        
        Test.stopTest();
        
        Integer jobCount = [SELECT COUNT() 
                            FROM AsyncApexJob 
                            WHERE JobType = 'ScheduledApex' 
                            AND Status = 'Queued'];
        System.assert(jobCount > 0, 'El trabajo programado debería estar en la cola');
    }
}
