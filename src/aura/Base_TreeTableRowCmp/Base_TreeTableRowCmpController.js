/**
 * 2018/10/18  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 * - Modified by Mei Xing 2018-12-26
 * - Add open log function
 */

({
    toggleExpandStatus: function(component, event, helper) {

        var hasInitNodes = component.get("v.hasInitNodes");
        var data = component.get("v.data");

        if(!!!hasInitNodes){
            component.set("v.hasInitNodes",true);
        }

        var status = component.get("v.expanded");

        component.set("v.expanded", !!!status);

        var compEvent = component.getEvent("rowAction");
        compEvent.setParam("type", 'expand');
        compEvent.setParam("data", {status:!!!status, index:data.record.Id});
        compEvent.fire();
    },
})