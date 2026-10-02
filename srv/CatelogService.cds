using { tyson.db.master, tyson.db.transaction } from '../db/datamodel';

service CatelogService @(path: 'CatelogService', requires: 'authenticated-user') {
    
    entity EmployeeSet@(restrict: [
                                    {grant:['READ'], to:'Display', 
                                        where: 'bankName = $user.bankNameFilter'},
                                    {grant: ['WRITE','DELETE'], to: 'Edit'}
                                ]) as projection on master.employees; 
    entity ProductSet as projection on master.product; 
    entity BusinessPartnerSet as projection on master.businesspartner; 
    entity AddressSet as projection on master.address; 
    @readonly
    entity StatusCode as projection on master.StatusCode; 
    @Capabilities : { Deletable: false }
    entity PurchaseOrderSet@(restrict: [
                                        { grant: ['READ'], to: 'Display' },
                                        { grant: ['WRITE','DELETE'], to: 'Edit' }
                                    ],
                                odata.draft.enabled: true,
                                Common.DefaultValuesFunction : 'getDefaultValues') as projection on transaction.purchaseorder{
        *,
        case when OVERALL_STATUS = 'A' then cast(3 as Integer)
            when OVERALL_STATUS = 'D' then cast(3 as Integer)
            when OVERALL_STATUS = 'X' then cast(1 as Integer)
            when OVERALL_STATUS = 'P' then cast(2 as Integer)
            when OVERALL_STATUS = 'N' then cast(3 as Integer)
            else cast(0 as Integer)
        end as colorcode : Integer,

        case when OVERALL_STATUS = 'A' then 'Approved'
            when OVERALL_STATUS = 'D' then 'Delivered'
            when OVERALL_STATUS = 'X' then 'Cancelled'
            when OVERALL_STATUS = 'P' then 'Pending'
            when OVERALL_STATUS = 'N' then 'New'
            else 'Unknown'
        end as OverallStatus : String(10)
        // case OVERALL_STATUS
        // when 'P' then 'Pending'
        // when 'A' then 'Approved'
        // when 'X' then 'Rejected'
        // when 'D' then 'Delivered'
        // else 'Unknown'
        // end as OverallStatus: String(10),

        // case OVERALL_STATUS
        // when 'P' then 2
        // when 'A' then 3
        // when 'X' then 1
        // when 'D' then 3
        // else 0
        // end as colorcode: Integer
    }
    actions{
        @cds.odata.bindingparameter.name: '_holdingvar'
        @Common.SideEffects : { 
            TargetProperties : [
                '_holdingvar/GROSS_AMOUNT',
                '_holdingvar/OVERALL_STATUS',
            ],
         }
        action boost() returns PurchaseOrderSet
    }; 

    entity PurchaseItemSet as projection on transaction.poitems; 

    function getLargestOrder() returns array of PurchaseOrderSet;   

    function getDefaultValues() returns PurchaseOrderSet;
}