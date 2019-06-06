public with sharing class DataMigratorHome {
    public static String instanceUrl;
    public static String access_Token;

    @AuraEnabled(cacheable = true)
    public static List<SalesforceOrg__c> getConnetecSaleforceOrg(){
        List<SalesforceOrg__c> salesforceOrgLst = new List<SalesforceOrg__c>();
        salesforceOrgLst = [Select Name, Id FROM SalesforceOrg__c Limit 20];
        return salesforceOrgLst;                    

    }

    /*
    * Method to validate the salesforce org connection credentials
    * If successfull save a record  within the SalesforceOrg__c Object
    * else send a failure message.
    */
    @AuraEnabled
    public static string validateConnection(String orgName,String userName,String pwd,String clientid,String clientsecret,boolean typeOfOrgIsSandbox){

        String message ;

        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+pwd;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type','application/x-www-form-urlencoded');
        req.setMethod('POST');
        if(typeOfOrgIsSandbox == true)
            req.setEndpoint('https://test.salesforce.com/services/oauth2/token?');
        else
            req.setEndpoint('https://login.salesforce.com/services/oauth2/token?');

        req.setBody(reqbody);
        HttpResponse res = h.send(req);
        system.debug('res>>>>>>>>>>>>>'+res.getBody());
        String resbody = res.getBody();
        Map<String,Object> response = (Map<String,Object>)JSON.deserializeUntyped(resbody);
        System.debug('Response status @@@@ ' + res.getStatus());
        System.debug('Response status code @@@@ ' + res.getStatusCode());
        if(res.getStatusCode() == 200){
            message = 'Success';
            //Insert a record in the SalesforceOrg__c object
            SalesforceOrg__c org = new SalesforceOrg__c();
            org.Name = orgName;
            org.UserName__c = userName;
            org.Password__c = pwd;
            org.Consumer_Key__c = clientid;
            org.Consumer_Secret__c = clientsecret;
            org.Type_Of_Org_Is_Sandbox__c = typeOfOrgIsSandbox;
            insert org;
        }else{
            message = 'Failed';
        }

        return message;
    } 
}
