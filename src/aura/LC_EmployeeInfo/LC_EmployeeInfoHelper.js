({
    getConfig : function(component) {
        var config = {
            objectApiName : 'Employee__c',
            filter : '',
            recordIds : [component.get("v.recordId")],
            fields : ['Name', 'Phone__c', 'Department__c','Position__c', 'Email__c', 
                         'Certificate__c'],
            hideFields : ['Department__r.Name']
        };

        this.getFieldDefinations(component, config);
    },

    getFieldDefinations : function(component, config) {
        var helper = this;

        component.find("sobjectType-service").getFieldsMap(config.objectApiName, config.fields)
                    .then(
                        $A.getCallback(
                            function(result){
                                var fieldDefinations = JSON.parse(JSON.stringify(result));
                                var fieldConfig = helper.resolveFieldDefination(component, fieldDefinations);
                                helper.getEmployeeRecord(component, config, fieldConfig);
                            },
                            function(error){
                                helper.showToast(component,error,"Error","error");
                            }
                        )
                    ).catch(function(e) {
                        helper.showToast(component,e,"Error","error");
                    });
    },

    resolveFieldDefination : function(component, fieldDefinations) {
        var fieldConfig = {fieldMap : []};
        var fieldsInFieldGroup = ['Name', 'Department__c','Email__c','Phone__c','Position__c'];
        var fieldGroup = {"fields" : [], "type": "field-group", "columnSize" : 9};
        for (var key in fieldDefinations) {
            var fieldDefination = fieldDefinations[key];
            if (fieldsInFieldGroup.indexOf(fieldDefination.name) > -1) {
                fieldDefination.columnSize = 10;
                fieldDefination.labelColumnSize = 5;
                fieldDefination.valueColumnSize = 7;
                if (fieldDefination.name === "Department__c") {
                    fieldDefination.referenceTargetField = "Name";
                }
                fieldGroup.fields.push(fieldDefination);
            } else {
                fieldDefination.columnSize = 12;
                fieldDefination.labelColumnSize = 7;
                fieldDefination.valueColumnSize = 7;
                fieldConfig.fieldMap.push(fieldDefination);
            }
        }
        fieldConfig.fieldMap.splice(0, 0, fieldGroup);

        return fieldConfig;
    },

    getEmployeeRecord : function(component, config, fieldConfig) {
        var helper = this;
        var fields = config.fields.concat(config.hideFields);
        component.find("record-service").getRecords(config.objectApiName, config.recordIds, fields, config.filter)
                    .then(
                        $A.getCallback(
                            function(result){
                                component.find("employee-detail").setData(JSON.parse(result)[0]);
                                component.find("employee-detail").setConfig(fieldConfig);
                            },
                            function(error){
                                helper.showToast(component,error,"Error","error");
                            }
                        )
                    ).catch(function(e) {
                        helper.showToast(component,e,"Error","error");
                    });
    },

    showToast : function(component, message, title, type) {
        component.find("show-toast").showToast(message,type);
    },
})