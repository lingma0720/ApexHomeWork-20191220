/**
 * 08/10/2018  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 */

({
    getRecordsMethod : function(component, event, helper) {
        var params = event.getParam('arguments');
        var objectName = params.objectName;
        var recordIds = params.recordIds;
        var fieldNames = params.fieldNames;
        var filter = params.filter;
        var orders = params.orders;
        var limit = params.limit;

        var action = component.get('c.getRecords');

        action.setParams({
            objectName : objectName,
            recordIds : recordIds,
            fieldNames : fieldNames,
            filter : filter,
            ordersJSON : orders,
            limitCount : limit
        });

        return component.find('actionService').invoke(action);
    },
})