sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"simon/po/poanalytics/test/integration/pages/PurchaseAnalyticsList.gen",
	"simon/po/poanalytics/test/integration/pages/PurchaseAnalyticsObjectPage.gen"
], function (JourneyRunner, PurchaseAnalyticsListGenerated, PurchaseAnalyticsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('simon/po/poanalytics') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseAnalyticsListGenerated: PurchaseAnalyticsListGenerated,
			onThePurchaseAnalyticsObjectPageGenerated: PurchaseAnalyticsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

