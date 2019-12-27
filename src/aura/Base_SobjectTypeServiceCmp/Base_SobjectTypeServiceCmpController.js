/**
 * Created by meixing on 2019-05-07.
 */
({
    getFieldsMapMethod : function(component, event, helper) {

        var params = event.getParam('arguments');
        var objectName = params.objectName;
        var fieldNames = params.fieldNames;
        var action = component.get('c.getFieldsMap');

        action.setParams({
            objectName : objectName,
            fieldNames : fieldNames
        });
        action.setStorable();

        return component.find('actionService').invoke(action);
    }
})