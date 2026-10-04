using { tyson.cds.CDSViews } from '../db/CDSViews';

service POAnalytics @(path: 'POAnalytics'){

    entity PurchaseAnalytics as projection on CDSViews.ProductView{
        *
    };

    

}
