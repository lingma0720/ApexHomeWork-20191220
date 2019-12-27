/**
 * Created by meixing on 2019-05-08.
 */
({
    configChange  : function(component, event, helper) {

         var data = component.get("v.data");
         var column = component.get("v.column");

         if(data && column){
            helper.initCellBody(component, data, column);
         }
    },
    doInit : function(component, event, helper) {
        var data = component.get("v.data");
        var column = component.get("v.column");

        if(data && column){
           helper.initCellBody(component, data, column);
        }
    },
    triggerClickable: function(component, event, helper) {
        var column = component.get("v.column"),
            data = {
                record: component.get("v.data")
            },
            compEvent = component.getEvent("recordChange");

        compEvent.setParam("type", column.options.onclickType);
        compEvent.setParam("data", data);
        compEvent.fire();
    },
    clickAction : function(component, event, helper) {
        var column = component.get("v.column");
        var rowIndex = component.get("v.rowIndex");

        var attributeName = event.getSource().get("v.name");
        var key = attributeName ? attributeName.split(":")[0] : null;
        var actionType = attributeName ? attributeName.split(":")[1] : null;

        var data = {};
        data.record = component.get("v.data");
        data.rowIndex = rowIndex;
        actionType = actionType || column.options.onclickType;

        if(!$A.util.isEmpty(column.list_cmps)){
            var attributeKey = helper.getAttributeKey(column,actionType);
            data[attributeKey] = key;
        }else {
            data[column.key] = key;
        }

        var compEvent = component.getEvent("recordChange");
        compEvent.setParam("type", actionType);
        compEvent.setParam("data", data);
        compEvent.fire();
    },
    changeAction : function(component, event, helper) {
        var column = component.get("v.column");
        var data = component.get("v.data");
        var keyAttribute = event.getSource().get("v."+column.keyAttribute);
        data[column.key] = keyAttribute;

        if(event.getSource().get("v.type") === 'checkbox'){
            var compEvent = component.getEvent("recordChange");
            compEvent.setParam("type", 'selectStatus');
            compEvent.setParam("data", {column:column.key});
            compEvent.fire();
        }
        //console.log(JSON.parse(JSON.stringify(data)));
    },
    inputClickAction : function(component, event, helper) {
        var column = component.get("v.column");
        var data = component.get("v.data");
        var keyAttribute = event.getSource().get("v."+column.keyAttribute);
        //console.log('keyAttribute ==> ' + keyAttribute);
        data[column.key] = !keyAttribute;
    }
})