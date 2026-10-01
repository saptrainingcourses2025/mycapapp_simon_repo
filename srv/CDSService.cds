using { tyson.cds.CDSViews } from '../db/CDSViews';

service CDSService @(path: 'CDSService'){

    entity ProductSet as projection on CDSViews.ProductView{
        *,
        virtual soldCount: Int16
    };
    entity ItemSet as projection on CDSViews.ItemView;

    

}
