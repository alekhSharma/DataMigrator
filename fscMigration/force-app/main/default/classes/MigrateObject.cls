public with sharing class MigrateObject {
   public class deserializeResponse{
        public String id;
        public String instance_url;
        public String access_token;
}
   
     public class oldid{
         public string id;
}

    public class newid{
        public string id;
        public boolean success;
}


@AuraEnabled
public static string migrateObjectDataInFSC(String objectName ,String FieldsName){
// REST JSON INsert to Another ORG
//list<account> acc=[select id,name from Account limit 4];

    String fetchRecords ='Select'+FieldsName+'From'+ objectName;
    List<sObject> sobjList = Database.query(fetchRecords)
    String a=json.serialize(sobjList);
    
    List<oldid> oldids=(List<oldid>)(JSON.deserialize(a, List<oldid>.class));
    system.debug(oldids);
    a= '{ "records":'+a+'}';
    a=a.replaceAll('"url"', '"referenceId"');
    a=a.replaceAll('"Id":"[0-9a-zA-Z]{18}",','');
    a=a.replaceAll(',"CurrencyIsoCode":"INR"','');
    system.debug(a);
    
    List<newid> newids=(List<newid>)(JSON.deserialize(MigrateObject.createObjectDataInFSC(a), List<newid>.class));
    system.debug(newids);
    
    Map<String,String> oldnew=new Map<String,String>();
    
    for(Integer i=0 ;i<oldids.size(); i++){
    if(newids[i].success==true){
         oldnew.put(oldids[i].id,newids[i].id);
    }     
    else{
        oldnew.put(oldids[i].id,'');
    }    
}

}


    @AuraEnabled
    public static String createObjectDataInFSC(string recordsinjson){
        
   			 String returnString;
        	 String clientId = '3MVG9d8..z.hDcPID9ny647qfnddsy2pzgWIMPmTm4WtechJ3U1f5XRV7MVdiKeEesmBW81iLO_aHKe3Y4tTb';
   			 String clientSecret = 'DCCD277119170B8B4EE6059AB174483BD6807F6062998FF2857366E356A83DCB';
   			 String username = 'pratiksha4@cognizant.com';
    		 String password = '@22pratik09R7Smm18PPhGLboDIQoLH4Ulcu';
			 String reqbody ='grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
      	// get Access token of another org
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse res = h.send(req);
       	deserializeResponse response=(deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
        system.debug('Rest auth'+res.getbody());
        // Rest API call to Insert Data
        String endPoint =response.instance_url+'/services/data/v45.0/composite/sObjects';   
		if(response.access_token != null){
        HttpRequest httpRequest = new HttpRequest(); 
        httpRequest.setMethod('POST'); 
        String requestBody=recordsinjson;
            system.debug('Rest enter');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setHeader('Authorization', 'Bearer ' + response.access_token);
        httpRequest.setBody(requestBody);
        httpRequest.setEndpoint(endPoint); 
        Http ht = new Http();  
        HttpResponse httpResponse = ht.send(httpRequest); 
        system.debug('Body'+httpResponse.getBody());
        returnString = httpResponse.getBody();
     }
       return returnString;
    }
}
