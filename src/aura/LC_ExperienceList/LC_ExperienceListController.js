/**
 * Created by meixing on 2019-10-05.
 */
({
    getExperiences : function(component, event, helper) {
        helper.setColumns(component);
        helper.setExperiences(component);
    },

    addExperience : function(component, event, helper) {
        helper.openEditorDialog(component, {});
    },

    saveExperience : function(component, event, helper) {
        var editorComponent = component.get("v.editor");
        var record = editorComponent.getRecord();

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

    confirmDelete : function(component, event, helper) {
        helper.closeDialog(component);

        var operatingRecord = component.get("v.operatingRecord");
        helper.removeRecord(component, operatingRecord);
    },
    cancelModel : function(component, event, helper) {
        helper.closeDialog(component);
    },
})