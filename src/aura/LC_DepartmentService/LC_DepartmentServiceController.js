/**
 * Created by meixing on 2019-10-05.
 */
({
    getDepartmentsByEmployeeId : function(component, event, helper) {
        var params = event.getParam('arguments');

        var action = component.get('c.getEmployeeDepartments');
        action.setParams({
            employeeId : params.employeeId
        });

        return component.find('actionService').invoke(action);
    },
})