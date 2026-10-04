using { tyson.cds.CDSViews } from '../db/CDSViews';

service POAnalytics @(path: 'POAnalytics'){

    entity PurchaseAnalytics as projection on CDSViews.POWorkList{
        *
    };

// Block1
    annotate POAnalytics.PurchaseAnalytics with @(
        Aggregation.ApplySupported  : {
            Transformations : [
                'aggregate',
                'identity',
                'topcount',
                'bottomcount',
                'concat',
                'groupby',
                'filter',
                'expand',
                'search'
            ],
            GroupableProperties : [
                CompanyName,
                Description,
                CurrencyCode,
                Country  
            ],
            AggregatableProperties : [
                {
                    $Type : 'Aggregation.AggregatablePropertyType',
                    Property : GrossAmount,
                },
            ],
        },
        Analytics : { 
            AggregatedProperty #GrossAmount: {
                $Type : 'Analytics.AggregatedPropertyType',
                Name : 'GrossAmount',
                AggregationMethod : 'sum',
                AggregatableProperty : GrossAmount,
                @Common.Label: 'Total Pruchase'
            },
         },
    );
    
// Block3
    annotate POAnalytics.PurchaseAnalytics with @(
        UI.Chart #visualfilter: {
            $Type : 'UI.ChartDefinitionType',
            ChartType : #Bar,
            Title: 'Filter by Company',
            Dimensions : [ Country ],
            DimensionAttributes : [
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : Country,
                    Role : #Category,
                },
            ],
            DynamicMeasures : [
                ![@Analytics.AggregatedProperty#GrossAmount]
            ],
            MeasureAttributes : [
                {
                    $Type : 'UI.ChartMeasureAttributeType',
                    DynamicMeasure : ![@Analytics.AggregatedProperty#GrossAmount],
                    Role : #Axis1,
                },
            ],
        },
        UI.PresentationVariant #pvvisualfilter : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.Chart#visualfilter',
            ],
        },
    )
    {
        Country @Common : { 
            ValueList #vlCountry: {
                $Type : 'Common.ValueListType',
                CollectionPath : 'PurchaseAnalytics',
                Parameters : [
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        LocalDataProperty : Country,
                        ValueListProperty : 'Country',
                    },
                ],
                PresentationVariantQualifier : 'pvvisualfilter',
            },
         }
    };

// Block4    
    annotate POAnalytics.PurchaseAnalytics with @(
        UI.Chart  : {
            $Type : 'UI.ChartDefinitionType',
            ChartType : #Column,
            Title: 'Total Purchase by Company',
            Dimensions : [ CompanyName ],
            DimensionAttributes : [
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : CompanyName,
                    Role : #Series,
                },
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : Country,
                    Role : #Category,
                },
            ],
            DynamicMeasures : [
                ![@Analytics.AggregatedProperty#GrossAmount]
            ],
            MeasureAttributes : [
                {
                    $Type : 'UI.ChartMeasureAttributeType',
                    DynamicMeasure : ![@Analytics.AggregatedProperty#GrossAmount],
                    Role : #Axis1,
                },
            ],
        },
        UI.PresentationVariant  : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.Chart',
            ],
        },
    );
    
// Block2
    annotate POAnalytics.PurchaseAnalytics with @(
        UI: {
            SelectionFields  : [                
                PurchaseOrderId,
                CompanyName,
                CurrencyCode,
                Description,
                Country
            ],
            LineItem  : [
                {
                    $Type : 'UI.DataField',
                    Value : PurchaseOrderId,
                },
                {
                    $Type : 'UI.DataField',
                    Value :  ItemPosition,
                },
                {
                    $Type : 'UI.DataField',
                    Value : CompanyName,
                },
                {
                    $Type : 'UI.DataField',
                    Value : GrossAmount,
                },
                {
                    $Type : 'UI.DataField',
                    Value : CurrencyCode,
                },
                {
                    $Type : 'UI.DataField',
                    Value : Description,
                },
                {
                    $Type : 'UI.DataField',
                    Value : OverallStatus,
                },
                {
                    $Type : 'UI.DataField',
                    Value : Country,
                },
            ],
        }
    ); 
}
