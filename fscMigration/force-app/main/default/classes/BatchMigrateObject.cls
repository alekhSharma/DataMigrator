global with sharing class BatchMigrateObject implements Database.Batchable<sObject> {
    String objectsetupname;
    String query;
    String authId;
    
    global BatchMigrateObject(String objectName,String fieldName, String authId,String objectsetupname) {
        this.objectsetupname=objectsetupname;
        this.authId=authId;
        this.query='SELECT'+fieldName+'FROM'+objectName;

    }

    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> sobjList){
      MigrateObject.migrateObjectDataInFSC(sobjList,authId,objectsetupname);
   }

   global void finish(Database.BatchableContext BC){
      AsyncApexJob a = [Select a.TotalJobItems, a.NumberOfErrors,a.JobItemsProcessed From AsyncApexJob a WHERE id = :BC.getJobId()];
      Batch_Transaction_Detail__c newBatch=new Batch_Transaction_Detail__c();
      newBatch.Batch_Failed__c= a.NumberOfErrors;
      newBatch.Batch_Id__c=BC.getJobId();
      newBatch.Batch_Success__c=a.JobItemsProcessed;
      newBatch.Object_setup_name__c=objectsetupname;
      newBatch.Total_Batch__c=a.TotalJobItems;

      insert newBatch;

   }

}
