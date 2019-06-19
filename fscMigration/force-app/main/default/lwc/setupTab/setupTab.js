/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';
import getObjectSetupWrapper from '@salesforce/apex/ObjectFieldSetup.getObjectSetupWrapper';

export default class SetupTab extends LightningElement {

    @api setupconnectedSalesforceOrgId;
    @track displayresult;
    @track sourceunmappedLst;
    @track destunmappedLst;

    connectedCallback() {
        getObjectSetupWrapper({ salesforceOrgId: this.setupconnectedSalesforceOrgId })
            .then(result => {
                if (result) {
                    console.log(result);
                    this.displayresult = result.mappedLst;
                    this.sourceunmappedLst = result.sourceunmappedLst;
                    this.destunmappedLst = result.destunmappedLst;
                }
            })
            .catch(error => {
                console.log(error);
            })
    }

    allowDrop(ev) {
        ev.preventDefault();
    }

    drag(ev) {
        ev.dataTransfer.setData("text", ev.currentTarget.getAttribute('data-id'));
    }

    drop(ev) {
        ev.preventDefault();
        let DestinationString = this.destunmappedLst.filter(unit => unit.Destination_Object_Api_Name__c === ev.dataTransfer.getData("text"));

        let DestinationUpdatedList = this.destunmappedLst.filter(unit => unit.Destination_Object_Api_Name__c !== ev.dataTransfer.getData("text"));
        this.destunmappedLst = DestinationUpdatedList;
        
        console.log('OUTSIDE THE MAP');
        console.log(DestinationString);
        this.sourceunmappedLst.map(function (unit) {
            if (unit != null || unit !== undefined) {
                if (unit.Name != null || unit.Name !== undefined) {
                    if (ev.currentTarget.childNodes[0].className !== null) {
                        if (unit.Name === ev.currentTarget.childNodes[0].className) {
                            console.log(DestinationString);
                            unit.Destination_Object_Api_Name__c = DestinationString[0].Destination_Object_Api_Name__c;
                            unit.Destination_Object_Name__c     = DestinationString[0].Destination_Object_Name__c;
                            }
                        }
                    }
                }
            }
        );
        console.log(this.sourceunmappedLst);
    }
}