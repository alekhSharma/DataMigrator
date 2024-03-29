import { LightningElement,track, wire } from 'lwc';
import getSalesforceOrgLst from '@salesforce/apex/DataMigratorHome.getConnetecSaleforceOrg';
import validateConnection from '@salesforce/apex/DataMigratorHome.validateConnection';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getFSLObjects from '@salesforce/apex/DataMigratorHome.getFSLObjects';import migrateObjectData from '@salesforce/apex/MigrateObject.migrateObjectDataInFSC';


export default class DataMigratorHome extends LightningElement {
    
    @wire(getSalesforceOrgLst)
    salesforceOrgLst;

    @track objectName;
    @track FieldsName;
    @track openmodal = false;
    @track orgName;
    @track userName;
    @track password;
    @track clientSecret;
    @track clientId;
    @track typeOfOrgIsSandBox = false;

    @track connectedSalesforceOrgId;
    @track connectedSalesforceOrgName;

    @track mappingObjLst = [];
    @track value = 'inProgress';
    @track options;

    newConnection(){
        this.openmodal = true;
        console.log('Open modal called');
    }

    handleOrgNameChange(event){
        this.orgName = event.target.value;
    }

    handleUserNameChange(event){
        this.userName = event.target.value;
    }

    handlePasswordChange(event){
        this.password = event.target.value;
    }
    
    handleClientSecretChange(event){
        this.clientSecret = event.target.value;
    }

    handleClientIdChange(event){
        this.clientId = event.target.value;
    }

    handleTypeOfOrgIsSandBox(event){
        this.typeOfOrgIsSandBox = event.target.checked;
    }

    saveDetails(){
        console.log('@@ Save Details called @@@@');
        console.log ('@@ Orgname @@ ' + this.orgName);
        console.log ('@@ Username @@ ' + this.userName);
        console.log ('@@ Password  @@ ' + this.password);
        console.log ('@@ Client id  @@ ' + this.clientId);
        console.log ('@@ Client secret  @@ ' + this.clientSecret);
        console.log ('@@ type of org is sand box  @@ ' + this.typeOfOrgIsSandBox);
        validateConnection({orgName:this.orgName,
            userName:this.userName,
            pwd:this.password,
            clientid:this.clientId,
            clientsecret:this.clientSecret,
            typeOfOrgIsSandbox:this.typeOfOrgIsSandBox})
            .then(result => {
            console.log('Validation Successfull Result from apex @@@ ' + result);
            if(result.includes('Success')){
                console.log('Success');
                const evt = new ShowToastEvent({
                    title: 'Connection Succesfull',
                    message: 'Your Connected Salesforce Org is successfully authenticated',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                refreshApex(this.salesforceOrgLst);
                this.openmodal = false;
            }//end of if
            else{
                const evt = new ShowToastEvent({
                    title: 'Connection Failed',
                    message: 'Could not authenticate the connected org. Please recheck your credentials',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            } 
            })
            .catch(error => {
            console.log('Validation catch')
            });

    }
    closeModal(){
        this.openmodal = false;
    }

    openSelectedOrg(event){
        console.log('Open selected org ');
        console.log(event.target.parentNode.className);
        this.connectedSalesforceOrgId = event.target.parentNode.className;
        getFSLObjects({salesforceOrgId : this.connectedSalesforceOrgId})
        .then(result =>{
            console.log('response @@@ ');
            console.log(result.stdObjectLst);
            console.log(result.fslPickList);
            let i;
            for( i = 0 ; i< result.stdObjectLst.length ; i++){
                let stdobj = {label:result.stdObjectLst[i],mapping:'none'};
                this.mappingObjLst.push(stdobj);
            }
            this.options = result.fslPickList;
            // console.log(this.mappingObjLst);  
        })
        .catch(error => {
            console.log(error);
        });

    }

    // get options() {
    //     return [
    //         { label: 'New', value: 'new' },
    //         { label: 'In Progress', value: 'inProgress' },
    //         { label: 'Finished', value: 'finished' },
    //     ];
    // }

    handleChange(event) {
        this.value = event.detail.value;
    }

}