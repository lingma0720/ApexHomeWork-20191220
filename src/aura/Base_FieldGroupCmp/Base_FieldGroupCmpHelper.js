/**
 * 2019/1/7  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 */

({
    getFieldValues : function(component){
        var helper = this;
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

                    if($A.util.isEmpty(record[field.relationshipName])){
                        fieldValues[field.relationshipName] = {};
                    }
                    fieldValues[field.relationshipName]['Id'] = selection[0].id;
                    fieldValues[field.relationshipName][field.titleField] = selection[0].title;
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
        }, {});
    },

})