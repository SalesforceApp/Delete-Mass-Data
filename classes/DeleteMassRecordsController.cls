public class DeleteMassRecordsController
{
    public String ObjectName {get; set;}
    public String FieldType {get; set;}
    
    public String FromDate {get; set;}
    public String ToDate {get; set;}
    
    public DeleteMassRecordsController()
    {
        FieldType = 'All Time';
    }
    
    public void deleteRecords()
    {   
        if(FieldType == 'All Time')
        {
            DeleteMassRecordsBatch deleteBatch = new DeleteMassRecordsBatch();
            deleteBatch.ObjectName = ObjectName;
            deleteBatch.query = 'select Id, Name from ' + ObjectName;
            Database.executeBatch(deleteBatch, 200);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You will receive an email once these records are deleted. Please check your email later. Please send an email to samba.gao@hotmail.com if you have any questions. Thanks.'));
        }
        else
        {
            if(String.isEmpty(FromDate))
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'From: You must enter a value.'));
            }
            else if(String.isEmpty(ToDate))
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'To: You must enter a value.'));
            }
            else
            {
                Date startDate = Date.parse(FromDate);
                Date endDate = Date.parse(ToDate);
                if(startDate > endDate)
                {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'To date must be on or after from date.'));    
                }
                else
                {
                    DeleteMassRecordsBatch deleteBatch = new DeleteMassRecordsBatch();
                    deleteBatch.ObjectName = ObjectName;
                    deleteBatch.FromDate = startDate;
                    deleteBatch.ToDate = endDate;
                    deleteBatch.query = 'select Id, Name from ' + ObjectName + ' where CreatedDate >= :FromDate and CreatedDate <= :ToDate';
                    Database.executeBatch(deleteBatch, 200);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You will receive an email once these records are deleted. Please check your email later. Please send an email to samba.gao@hotmail.com if you have any questions. Thanks.'));
                }
            }
        }
    }
    
    public List<SelectOption> Objects
    {
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('NONE', 'Standard Objects'));
            options.add(new SelectOption('Account', '--Account'));
            options.add(new SelectOption('Contact', '--Contact'));
            options.add(new SelectOption('Lead', '--Lead'));
            options.add(new SelectOption('Opportunity', '--Opportunity'));
            options.add(new SelectOption('Task', '--Task'));
            options.add(new SelectOption('Case', '--Case'));
            options.add(new SelectOption('Attachment', '--Attachment'));
            options.add(new SelectOption('NONE', 'Custom Objects'));
            Map<String, Schema.SObjectType> sObjects = Schema.getGlobalDescribe();
            for(String item :sObjects.keySet())
            {
                if(item.endsWith('__c'))
                {
                    options.add(new SelectOption(item, '--' + sObjects.get(item).getDescribe().getLabel()));
                }
            }
            
            return options;
        }
    }
}