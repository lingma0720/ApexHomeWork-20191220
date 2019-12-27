({
    getFieldLabelAction : function(component, event, helper) {
        const params = event.getParam('arguments');
        const action = component.get('c.getFieldLabelService');
        action.setParams({
            "objApiNameList" : params.objectAPINameList,
            "objApiName2FieldsMap":params.objectFieldAPINameMap
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === 'SUCCESS') {
                params.callback(response.getReturnValue());
            } else if (state === 'ERROR') {
                const errors = response.getError();
                if (errors) {
                    console.error(JSON.stringify(errors));
                } else {
                    console.error('Unknown error');
                }
            }
        });

        $A.enqueueAction(action);
    }
})