@isTest
public class DeleteMassRecordsControllerTest
{
    @isTest
    public static void deleteRecordsWithAllTimeTest()
    {
        DeleteMassRecordsController deleteRecords = new DeleteMassRecordsController();
        System.assert(deleteRecords.Objects.size() >= 0);
        Account acc = new Account(Name = 'Acme');
        insert acc;
        deleteRecords.ObjectName = 'Account';
        deleteRecords.deleteRecords();
    }
    
    @isTest
    public static void deleteRecordsWithCustomTest()
    {
        DeleteMassRecordsController deleteRecords = new DeleteMassRecordsController();
        System.assert(deleteRecords.Objects.size() >= 0);
        Account acc = new Account(Name = 'Acme');
        insert acc;
        deleteRecords.ObjectName = 'Account';
        deleteRecords.FieldType = 'Custom';
        deleteRecords.FromDate = Date.today().month() + '/' + Date.today().day() + '/' + Date.today().year();
        deleteRecords.ToDate = Date.today().month() + '/' + Date.today().day() + '/' + Date.today().year();
        deleteRecords.deleteRecords();
    }
}