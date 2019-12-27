({
    getemployeeInfor : function(component) {
    	let action = component.get("c.getEmployeeDetails");
    	action.setParams({
            "employeeId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let results = response.getReturnValue();
                console.log(results);
                component.set("v.employeeList", results);
            } else {
                console.info("Failed with state: " + response);
            }
        });
        $A.enqueueAction(action);
    }
})