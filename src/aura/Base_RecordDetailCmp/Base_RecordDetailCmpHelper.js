/**
 * Created by meixing on 2019-05-08.
 */
({
    getFieldValues : function(component){

        var originRecord = component.get("v.record");
        var clonedRecord = {};//JSON.parse(JSON.stringify(originRecord));

        var fieldComponents = component.find("input-cmp");

        if($A.util.isEmpty(fieldComponents)) return {};

        if(!$A.util.isArray(fieldComponents)) fieldComponents = [fieldComponents];

        //reduce all the field values into one object
        return fieldComponents.reduce(function(fieldValues, fieldCmp){
            var field = fieldCmp.get("v.field");

            if($A.util.isEmpty(field)) return fieldValues;

            var value = fieldCmp.getValue();

            if(field.type === 'reference'){
                var selection = fieldCmp.get("v.selections");
                if(!$A.util.isEmpty(selection)){
                    fieldValues[field.name] = selection[0].id;

                    if($A.util.isEmpty(fieldValues[field.relationshipName])){
                        fieldValues[field.relationshipName] = {};
                    }
                    fieldValues[field.relationshipName]['Id'] = selection[0].id;
                    fieldValues[field.relationshipName][field.referenceTargetField] = selection[0].title;
                }else{
                    fieldValues[field.name] = null;
                    fieldValues[field.relationshipName] = undefined;
                }
            }else if(field.type == 'field-group'){
                Object.assign(fieldValues, value);
            }else{
                fieldValues[field.name] = value;
            }

            return fieldValues;
        }, clonedRecord);
    },
    setOptions : function(component, fieldComponents, fieldName, options){
        var helper = this;
        for(var i = 0; i < fieldComponents.length; i++){
            var field = fieldComponents[i].get("v.field");
            var record = {};
            if (!field) continue;

            if(field.type === 'field-group'){
                var inputCmps = fieldComponents[i].find("input-cmp");

                for(var j = 0; j < inputCmps.length; j++){
                    var itemField = inputCmps[j].get("v.field");
                    if (!itemField) continue;

                    if(itemField.name === fieldName){
                        helper.resolveOption(inputCmps[j], itemField, options, fieldName, record);
                    }

                }
            }else if(field.name === fieldName){
                helper.resolveOption(fieldComponents[i], field, options, fieldName, record);
            }
        }
    },
    resolveOption : function(fieldComponent, field, options, fieldName, record){
        field.picklistValues = options;
        record[fieldName] = '';
        if(!field.placeholder){
            field.placeholder = '';
        }
        if($A.util.isEmpty(options)){
            field.disabled = true;
        }else{
            field.disabled = false;
        }
        fieldComponent.setValue(record);
        fieldComponent.set("v.field",field);
    }
})