({
    calculateDate : function(component, event, helper) {
        var record = component.get("v.record");
        if (!$A.util.isEmpty(record.Period__c)) {
            helper.calculateDate(component, record.Period__c);
        }
    },

    getRecord : function(component, event, helper) {
        var record = component.get("v.record");
        record.Period__c = helper.calculatePeriod(component);
        return record;

    }
})