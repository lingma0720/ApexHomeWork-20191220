({
    setValue  : function(component) {

        var helper = this;

    	var record = component.get("v.record");
        var field = component.get("v.field");
        //console.log('record==>',JSON.parse(JSON.stringify(record)));
        //console.log(field);
        if(record && field){
            if(field.type === 'reference'){
                if(record[field['relationshipName']]){

                    component.set("v.value", record[field['relationshipName']][field.referenceTargetField]);
                    component.set("v.url", '/'+record[field.name]);
                }else{
                    component.set("v.value", "");
                    component.set("v.url", "");
                }

            }else if(field.type === 'string' && !$A.util.isEmpty(field.referenceTargetField)){
                //console.log(JSON.parse(JSON.stringify(record)),field.name,field['relationshipName'],field.referenceTargetField);
                component.set("v.value", record[field['relationshipName']][field.referenceTargetField])

            }else if(field.type === 'picklist' || field.type === 'multipicklist'){
                component.set("v.value", helper.reducePicklistLabel(field.picklistValues, record[field.name]));

            }else{

                component.set("v.value", record[field.name]);
            }
        }
    },
    reducePicklistLabel : function(options, value){

        if($A.util.isEmpty(options) || $A.util.isUndefinedOrNull(value)) return [];

        var values = value.split(';');
        if($A.util.isEmpty(values)) return [];

        return options.reduce(function(prev, item){
            if( values.includes(item.value)) prev.push(item.label);
            return prev;
        },[]).join(';');
    }
})