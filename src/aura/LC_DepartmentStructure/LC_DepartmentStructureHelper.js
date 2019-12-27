/**
 * Created by meixing on 2019-10-05.
 */
({
    setColumns : function(component) {
        var columns = [{name:'',label:'',type:'',sortable:false},
                        {name:'',label:'时间',type:'string',sortable:false},
                        {name:'PrimaryContact__r.Name',label:'学校名称',type:'reference',sortable:false},
                        {name:'PrimaryContact__r.Phone__c',label:'Contact Phone',type:'string',sortable:false}];

        component.set("v.columns", columns);
    },

    setDepartmentStructure : function(component){
        var helper = this;

        component.find("department-service").getEmployeeDepartments(component.get("v.employeeId"))
                    .then(
                        $A.getCallback(
                            function(result){
                                component.set("v.departments", result);
                                component.set("v.departmentStructure", helper.resolveDepartmentStructure(result));
                            },
                            function(error){
                                helper.showToast(component,error,"Error","error");
                            }
                        )
                    ).catch(function(e) {
                        helper.showToast(component,e,"Error","error");
                    });
    },

    resolveDepartmentStructure : function(departments) {
        var parentRow = {};
        departments.forEach(function(department) {
            if ($A.util.isEmpty(department.Parent__c)){

                parentRow.record = department;
                parentRow.level = 1;
                parentRow.disable = false;
                parentRow.selected = false;
                parentRow.nodeDisableSelect = true;
            }
        });

        return parentRow;
    },

    getSubData : function(component) {
        var departments = component.get("v.departments");
        var parentRowId = component.get("v.departmentStructure.record.Id");

        var childRow = {};
        departments.forEach(function(department) {
            if (department.Parent__c === parentRowId) {
                childRow.record = department;
                childRow.disable = true;
                childRow.level = 2;
            }
        });

        component.set("v.departmentStructure.nodes", [childRow]);
    },

    showToast : function(component, message, title, type) {
        component.find("show-toast").showToast(message,type);
    },
})