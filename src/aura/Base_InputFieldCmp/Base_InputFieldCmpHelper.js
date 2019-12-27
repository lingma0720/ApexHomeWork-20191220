({
    setValue : function(component) {
    	var record = component.get("v.record");
        var field = component.get("v.field");
        var selections = component.get("v.selections");
        var value = component.get("v.value");

        //console.log(JSON.parse(JSON.stringify(field)));

        if(record && field){
            if(field.type === 'reference'){
                if(record[field['relationshipName']]){
                    if(field.disabled){
                        component.set("v.value", record[field['relationshipName']][field.referenceTargetField]);
                        component.set("v.url", '/'+record[field.name]);
                    }
                    //console.log(record[field.name] ,selections[0].id);
                    if(!$A.util.isEmpty(selections) && record[field.name] == selections[0].id){
                    }else{
                        //console.log(field.referenceTargetField);
                        selections = [];
                        var title = record[field['relationshipName']][field.referenceTargetField];
                        //console.log(title);
                        selections.push({id: record[field.name],
                                  title:title,
                                icon:field.iconName});
                        //console.log(field.iconName,JSON.stringify(selections));
                        component.set("v.selections", selections);
                    }

                }else{
                    if(!$A.util.isEmpty(selections)){
                        selections = [];
                        component.set("v.selections", selections);
                    }
                }
              /*if(!$A.util.isEmpty(value) && $A.util.isEmpty(record[field.name])){
               component.set("v.value", '');
              }*/

            }else{

              if((!$A.util.isEmpty(value) != !$A.util.isEmpty(record[field.name]))
                || (!$A.util.isEmpty(value) && !$A.util.isEmpty(record[field.name])
                  && value != record[field.name]) ){
                component.set("v.value", record[field.name]);
              }

              if(field.type === 'multipicklist'){
                  var inputDelegateCmp = component.find("input-delegate");
                  if(!$A.util.isEmpty(inputDelegateCmp)){
                      return inputDelegateCmp.flush();
                  }
              }
           }

        }
    },
    /*
    setRecord : function(component) {
      var record = component.get("v.record");
      var field = component.get("v.field");
      var value = component.get("v.value");

      if(field.type === 'reference'){
        var selectedUser = field.selection[0];
        record[field.name] = selectedUser.id;
      }else{
        record[field.name] = value;
      }

    },*/
})