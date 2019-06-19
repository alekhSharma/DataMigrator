import { LightningElement, track, api } from 'lwc';

export default class DataMigratorMain extends LightningElement {

    @api connectedSalesforceOrgId;
    @api connectedSalesforceOrgName;

    @track selectedProfile = [];
    @track displayresult;

}