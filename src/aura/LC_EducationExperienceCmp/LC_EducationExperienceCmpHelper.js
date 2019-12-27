({
    setColumns : function(component) {
        var helper = this;

        var columns = [];
        columns.push(helper.getActionColumn());

        if(component.get("v.isEducation")){
            columns = columns.concat(helper.getEducationsColumns());
        }
        component.set("v.columns", columns);
    },

    getEducationsColumns : function() {
        return [{name:'Period__c',label:'时期',type:'string',sortable:false},
                {name:'SchoolName__c',label:'学校名称',type:'string',sortable:false}];
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

    setEducations : function(component) {
        var helper = this;
        var fields = helper.getQueryFields(component);
        var filter = helper.getQueryFilter(component) + ' AND RelatedTo__c = \'' + component.get("v.employeeId") + '\'';
        component.find("record-service").getRecords('Experience__c', [], fields, filter)
                    .then(
                        $A.getCallback(
                            function(result){
                                component.set("v.educations", JSON.parse(result));
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
        if (component.get("v.isEducation")) {
            return 'RecordType.DeveloperName = \'Educational_Experience\'';
        }
    },

    getQueryFields : function(component) {
        if (component.get("v.isEducation")) {
            return ['Id', 'Period__c', 'SchoolName__c' ];
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
        var experiences = component.get("v.educations");
        experiences.splice(operatingRecord.rowIndex, 1);

        component.set("v.educations", experiences);
    },

    openEditorDialog : function(component, operatingRecord) {
        var helper = this;
        component.set("v.operatingRecord", operatingRecord);
        let recordId = component.get("v.operatingRecord");
        console.log("recordId--------128--->" + JSON.stringify(recordId));
        $A.createComponents([
                ["c:LC_EducationEditorCmp", {record:operatingRecord, isEducation:component.get("v.isEducation")}],
                ["lightning:button",{label:"Save", variant:"brand", class:"slds-m-horizontal--large slds-float_left", onclick:component.getReference("c.saveEducations")}],
                ["lightning:button",{label:"Cancel", class:"slds-m-horizontal--large slds-float_right", onclick:component.getReference("c.cancelModel")}]
            ],
           function(components, status) {
               if (status === "SUCCESS") {
                    var footerBody = [components[1],components[2]];
                    component.set("v.editor", components[0]);
                    component.find('overlayLib').showCustomModal({
                       header: "Education Editor",
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

    updateEducations : function(component, operatingRecord) {
        var educations = component.get("v.educations");

        var isFound = false;
        for(var index = 0; index < educations.length; index ++) {
            var item = educations[index];
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
            educations.push(operatingRecord);
        }

        component.set("v.educations", educations);
        this.saveEducationExperiences(component, educations);
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

    saveEducationExperiences : function (component, educationList) {
       let action = component.get("c.updateExperiencesList");
       var employeeId = component.get("v.employeeId");
        action.setParams({
            "experienceList": JSON.stringify(educationList),
            "employeeId" : employeeId,
            "recordType" : "Educational_Experience"


        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log("result---210--->" + JSON.stringify(result));
                alert("保存成功");
                component.set("v.educations", result);
            } else {
                console.info("Failed with state: " + response);
            }
        });
        $A.enqueueAction(action);
    }
})