({
   getExperiences : function(component, event, helper) {
        helper.setColumns(component);
        helper.setExperiences(component);
    },

    addExperience : function(component, event, helper) {
        let employeeId = component.get("v.employeeId");
        console.log("employeeId----->" + JSON.stringify(employeeId));
        helper.openEditorDialog(component, {});
        //helper.openEditorDialog(component,employeeId);
    },

    saveExperience : function(component, event, helper) {
        var editorComponent = component.get("v.editor");
        var record = editorComponent.getRecord();
        console.log("record---17" + JSON.stringify(record));
        helper.updateExperiences(component, record);
        helper.closeDialog(component);
    },

    doRecordAction : function(component, event, helper) {
        var actionType = event.getParam('type');
        var data = event.getParam('data');
        //console.log('actionType:::' + actionType + ',data:::' + JSON.stringify(data));

        if (actionType === 'delete') {
            var confirmMsg = "Are you confirm to delete this record ?";
            var confirmBtn = "Confirm";
            var operatingRecord = {'Id' : data.Id, 'sobjectType' : 'Campaign', 'rowIndex' : data.rowIndex};
            helper.openConfirmDialog(component, confirmMsg, confirmBtn, operatingRecord);
        } else if (actionType === 'edit') {
            var rowIndex = data.rowIndex;
            if(!$A.util.isEmpty(rowIndex)) {
                var operatingRecord = component.get("v.experiences")[rowIndex];
                operatingRecord.rowIndex = rowIndex;
                helper.openEditorDialog(component, operatingRecord);
            }
        } else {

        }
    },
    editExperInfor : function(component, event, helper) {
        var target = event.getSource();
        console.log('target====>>>',target);
        var operatingRecord = target.get("v.value");
        console.log('operatingRecord===>',operatingRecord);
        helper.openEditorDialog(component, operatingRecord);
    },
    confirmDelete : function(component, event, helper) {
        helper.closeDialog(component);

        var operatingRecord = component.get("v.operatingRecord");
        console.log('operatingRecord===>',operatingRecord);
        helper.removeRecord(component, operatingRecord);
    },
    cancelModel : function(component, event, helper) {
        helper.closeDialog(component);
    },
})