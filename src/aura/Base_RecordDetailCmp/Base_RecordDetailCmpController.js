({
    setConfig : function(component, event, helper){
        var params = event.getParam('arguments');
        //console.log('config====>', JSON.stringify(params.config));
        component.set("v.config", params.config);
    },

    setData : function(component, event, helper){
        var params = event.getParam('arguments');
        component.set("v.record", params.record);
    },

    getData : function(component, event, helper) {

        var fieldValues = helper.getFieldValues(component);

        return fieldValues;
    },

    validate : function(component, event, helper) {
        var fieldComponents = component.find("input-cmp");

        if($A.util.isEmpty(fieldComponents)) return true;

        if(!$A.util.isArray(fieldComponents)) fieldComponents = [fieldComponents];

        for(var i = 0; i < fieldComponents.length; i++){
            var fieldComponent = fieldComponents[i];
            if(typeof fieldComponent.checkValidity == 'function'){
                if(!fieldComponent.checkValidity()){
                    return false;
                }
            }
        }

        return true;
    },

    setOptions: function(component, event, helper) {
        var params = event.getParam('arguments');
        var fieldName = params.field;
        var options = params.options;

        var fieldComponents = component.find("input-cmp");
        if($A.util.isEmpty(fieldComponents)) return {};
        if(!$A.util.isArray(fieldComponents)) fieldComponents = [fieldComponents];

        helper.setOptions(component, fieldComponents, fieldName, options);
    }
})