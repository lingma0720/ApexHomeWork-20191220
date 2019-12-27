({
    doInit : function(component, event, helper) {
         helper.setValue(component);
    },
    recordChange : function(component, event, helper) {
        helper.setValue(component);
    },
    getValue : function(component, event, helper) {
    	var value = component.get("v.value");
        var field = component.get("v.field");
        var inputDelegateCmp = component.find("input-delegate");
        if(field.type == 'string'){
            if(!$A.util.isEmpty(inputDelegateCmp) && inputDelegateCmp.getElement()){
                value = inputDelegateCmp.getElement().value;
            }
        }

        return value;
    },
    setValue :function(component, event, helper) {
         var params = event.getParam('arguments');
         var record = params.record;
         var field = component.get("v.field.name");
         //console.log(field,JSON.parse(JSON.stringify(record)));

         component.set("v.value",record[field]);
         console.log(component.get("v.value"));
    },
    lookupSearch : function(component, event, helper) {
    	var field = component.get("v.field");
    	component.find('input-delegate').search(field.searchAction);
    },
    lookupChange : function(component, event, helper) {
        var field = component.get("v.field");
        //console.log('lookupChange In');
        if(field.changeAction){

            var compEvent = component.getEvent("recordChange");
            compEvent.setParam("type", field.actionName);
            compEvent.fire();
        }
    },
    valueChange: function(component, event, helper) {
        var field = component.get("v.field");
        //console.log('valueChange In');

        if(field.changeAction){
            var value = component.get("v.value");

            var data = {};
            data[field.name] = value;

            var compEvent = component.getEvent("recordChange");
            compEvent.setParam("type", field.actionName);
            compEvent.setParam("data", data);
            compEvent.fire();
        }
    },
    validate: function(component, event, helper) {

        var inputDelegateCmp = component.find("input-delegate");
        var field = component.get("v.field");
        if(!$A.util.isEmpty(inputDelegateCmp)){
            if(typeof inputDelegateCmp.checkValidity == 'function'){
                return inputDelegateCmp.checkValidity();
            }else if(field.type == 'string'){
                return !field.required || inputDelegateCmp.getElement().value;
            }else{
                return true;
            }
        }
    },
})