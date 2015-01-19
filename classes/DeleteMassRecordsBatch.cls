global class DeleteMassRecordsBatch implements Database.Batchable<sObject>, Database.Stateful
{
    public String query;
    public Integer numberOfObjects;
    public Integer failures;
    public String ObjectName {get; set;}
    public Date FromDate {get; set;}
    public Date ToDate {get; set;}
    
    public DeleteMassRecordsBatch()
    {
        numberOfObjects = 0;
        failures = 0;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> deleteObjects)
    {
        Database.DeleteResult[] drl = Database.delete(deleteObjects, false);
        for(Database.DeleteResult item : drl)
        {
            if(item.isSuccess())
            {
                numberOfObjects ++;
            }
            else
            {
                failures ++;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        User user = [select Email from User where Id = :UserInfo.getUserId()];
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {user.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Delete Mass Records for the ' + ObjectName + ' Object');
        String result = 'Completed: ' + numberOfObjects + '. Failed: ' + failures;
        mail.setPlainTextBody(result);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}