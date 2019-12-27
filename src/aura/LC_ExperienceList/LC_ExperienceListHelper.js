/**
 * Created by meixing on 2019-10-05.
 */
({
    setColumns : function(component) {
        var helper = this;

        var columns = [];
        columns.push(helper.getActionColumn());

        if(component.get("v.isWorkExperience")){
            columns = columns.concat(helper.getWorkExperienceColumns());
        }else {
            columns = columns.concat(helper.getProjectExperienceColumns());
        }

        component.set("v.columns", columns);
    },

    getWorkExperienceColumns : function() {
        return [{name:'Period__c',label:'Period',type:'string',sortable:false},
                {name:'CompanyName__c',label:'Company Name',type:'string',sortable:false},
                {name:'CompanyPosition__c',label:'Company Position',type:'string',sortable:false},
                {name:'CompanyContactPhone__c',label:'Company Contact Phone',type:'string',sortable:false}];
    },

    getProjectExperienceColumns : function() {
        return [{name:'Period__c',label:'Period',type:'string',sortable:false},
                {name:'AccountName__c',label:'Account Name',type:'string',sortable:false},
                {name:'ProjectName__c',label:'Project Name',type:'string',sortable:false},
                {name:'ProjectPosition__c',label:'Project Position',type:'string',sortable:false}];
    },

    getActionColumn : function() {
        var actions = [];

        var editAttribute = {};
        editAttribute.iconName = "utility:edit";
        editAttribute.variant = "bare";
        editAttribute.disabled = false;
        editAttribute.alternativeText = "edit";
        editAttribute.name = "edit";
        var actionlog = {
            componentName: 'lightning:buttonIcon',
            componentAttribute: editAttribute,
            key: 'Id',
            sort: false
        };
        actions.push(actionlog);

        var deleteAttribute = {};
        deleteAttribute.iconName = "utility:delete";
        deleteAttribute.variant = "bare";
        deleteAttribute.disabled = false;
        deleteAttribute.alternativeText = "delete";
        deleteAttribute.name = "delete";
        var actiondelete = {
            componentName: 'lightning:buttonIcon',
            componentAttribute: deleteAttribute,
            key: 'Id',
            sort: false
        };
        actions.push(actiondelete);

        var action = {
            type: 'components',
            list_cmps: actions
        }

        return action;
    },

    setExperiences : function(component) {
        var helper = this;
        var fields = helper.getQueryFields(component);
        var filter = helper.getQueryFilter(component) + ' AND RelatedTo__c = \'' + component.get("v.employeeId") + '\'';
        component.find("record-service").getRecords('Experience__c', [], fields, filter)
                    .then(
                        $A.getCallback(
                            function(result){
                                component.set("v.experiences", JSON.parse(result));
                            },
                            function(error){
                                helper.showToast(component,error,"Error","error");
                            }
                        )
                    ).catch(function(e) {
                        helper.showToast(component,e,"Error","error");
                    });
    },

    getQueryFilter : function(component) {
        if (component.get("v.isWorkExperience")) {
            return 'RecordType.DeveloperName = \'Work_Experience\'';
        }

        if (component.get("v.isProjectExperience")) {
            return 'RecordType.DeveloperName = \'Project_Experience\'';
        }
    },

    getQueryFields : function(component) {
        if (component.get("v.isWorkExperience")) {
            return ['Id', 'Period__c', 'CompanyName__c', 'CompanyPosition__c', 'CompanyContactPhone__c', 'Description__c'];
        }

        if (component.get("v.isProjectExperience")) {
            return ['Id', 'Period__c', 'AccountName__c', 'ProjectPosition__c', 'ProjectName__c', 'Description__c'];
        }
    },

    openConfirmDialog :  function(component, comfirmInfo, confirmBtn, data) {
        var helper = this;
        component.set("v.operatingRecord", data);
        $A.createComponents([
                ["ui:outputText", {variant : "label-hidden",value:comfirmInfo}],
                ["lightning:button",{label:confirmBtn,variant:"brand",onclick:component.getReference("c.confirmDelete")}],
                ["lightning:button",{label:"Cancel",onclick:component.getReference("c.cancelModel")}]
            ],
           function(components, status) {
               if (status === "SUCCESS") {
                    var footerBody = [components[1],components[2]];

                    component.find('overlayLib').showCustomModal({
                       body: components[0],
                       showCloseButton: true,
                       footer: footerBody,
                       cssClass: "confirmDialog",
                       closeCallback: function() {
                       }
                   });

               }
           }
        );
    },

    removeRecord : function(component, operatingRecord) {
        var operatingRecord = component.get("v.operatingRecord");
        var experiences = component.get("v.experiences");
        experiences.splice(operatingRecord.rowIndex, 1);

        component.set("v.experiences", experiences);
    },

    openEditorDialog : function(component, operatingRecord) {
        var helper = this;
        component.set("v.operatingRecord", operatingRecord);
        $A.createComponents([
                ["c:LC_ExperienceEditor", {record:operatingRecord, isWorkExperience:component.get("v.isWorkExperience"), isProjectExperience:component.get("v.isProjectExperience")}],
                ["lightning:button",{label:"Save", variant:"brand", class:"slds-m-horizontal--large slds-float_left", onclick:component.getReference("c.saveExperience")}],
                ["lightning:button",{label:"Cancel", class:"slds-m-horizontal--large slds-float_right", onclick:component.getReference("c.cancelModel")}]
            ],
           function(components, status) {
               if (status === "SUCCESS") {
                    var footerBody = [components[1],components[2]];
                    component.set("v.editor", components[0]);
                    component.find('overlayLib').showCustomModal({
                       header: "Experience Editor",
                       body: components[0],
                       showCloseButton: true,
                       footer: footerBody,
                       cssClass: "editordialog",
                       closeCallback: function() {LC_ExperienceEditorLC_ExperienceEditor
                       }
                   });

               }
           }
        );
    },

    updateExperiences : function(component, operatingRecord) {
        var experiences = component.get("v.experiences");

        var isFound = false;
        for(var index = 0; index < experiences.length; index ++) {
            var item = experiences[index];
            if (!$A.util.isEmpty(operatingRecord.rowIndex) &&
                operatingRecord.rowIndex === index) {

                item = Object.assign(item, operatingRecord);
                isFound = true;
                break;
            }

            if (!$A.util.isEmpty(operatingRecord.Id) &&
                operatingRecord.Id === item.Id) {

                item = Object.assign(item, operatingRecord);
                isFound = true;
                break;
            }
        }

        if (!isFound) {
            experiences.push(operatingRecord);
        }

        component.set("v.experiences", experiences);
    },

    closeDialog : function(component){
        var helper = this;
        var cmp = component.find("overlayLib");
        if (!$A.util.isEmpty(cmp)) {
            cmp.close();
            helper.modelbody = null;
        }
    },

    showToast : function(component, message, title, type) {
        component.find("show-toast").showToast(message,type);
    },
})