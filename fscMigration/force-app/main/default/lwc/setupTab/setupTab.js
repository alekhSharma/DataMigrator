import { LightningElement, api, track, wire } from 'lwc';
import getObjectSetupWrapper from '@salesforce/apex/ObjectFieldSetup.getObjectSetupWrapper';

export default class SetupTab extends LightningElement {

    @api setupconnectedSalesforceOrgId;
    @track displayresult;

    @wire(getObjectSetupWrapper, {salesforceOrgId:'$setupconnectedSalesforceOrgId' })
    ObjectSetupDetails(result, error){
        if(result){
            if(result.data){
                this.displayresult = result.data.mappedLst;
                console.log(result.data.mappedLst);
                console.log(result.data.sourceunmappedLst);
                console.log(result.data.destunmappedLst);
            }
            
        }
        if(error){
            console.log(error);
        }
    }
}