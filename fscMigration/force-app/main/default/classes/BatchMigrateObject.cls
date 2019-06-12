public with sharing class BatchMigrateObject implements Database.Batchable<sObject> {
    String objectsetupname;
    String query;
    String authId;
    
    public BatchMigrateObject(String objectName,String fieldName, String authId,String objectsetupname) {
        objectsetupname=this.objectsetupname;
        authId=this.authId;
        query='SELECT'+this.fieldName+'FROM'+this.objectName;

    }

    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> sobjList){
      MigrateObject.migrateObjectDataInFSC(sobjList,authId,objectsetupname);
   }

   global void finish(Database.BatchableContext BC){

   }

}
