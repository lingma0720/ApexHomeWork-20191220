({
    setColumns : function(component) {
        var helper = this;

        var columns = helper.getEducationExperienceColumns();
        columns.push(helper.getActionColumn());
        var column = [];
        if(component.get("v.isProjectExperience")){
            columns = columns.concat(column);
        }

        component.set("v.columns", columns);
    },

    getEducationExperienceColumns : function() {
        return [{name:'Period__c',label:'时期：',type:'string',sortable:false},
                {name:'ProjectName__c',label:'项目名称：',type:'string',sortable:false},
                {name:'ProjectPosition__c',label:'职位：',type:'string',sortable:false}];
    },

    getActionColumn : function() {
        var actions = [];

        var editAttribute = {};
        editAttribute.label = "edit";
        editAttribute.variant = "brand";
        editAttribute.disabled = false;
        //editAttribute.alternativeText = "edit";
        editAttribute.name = "edit";
        var actionlog = {
            componentName: 'lightning:button',
            componentAttribute: editAttribute,
            key: 'Id',
            sort: false
        };
        actions.push(actionlog);

        var deleteAttribute = {};
        deleteAttribute.label = "delete";
        deleteAttribute.variant = "brand";
        deleteAttribute.disabled = false;
        //deleteAttribute.alternativeText = "delete";
        deleteAttribute.name = "delete";
        var actiondelete = {
            componentName: 'lightning:button',
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
                                component.set("v.partList", JSON.parse(result));
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
        if (component.get("v.isProjectExperience")) {
            return 'RecordType.DeveloperName = \'Project_Experience\'';
        }
    },

    getQueryFields : function(component) {
        if (component.get("v.isProjectExperience")) {
            return ['Id', 'Period__c', 'ProjectName__c', 'ProjectPosition__c', 'Description__c'];
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

        component.set("v.partList", experiences);
    },

    openEditorDialog : function(component, operatingRecord) {
        var helper = this;
        component.set("v.operatingRecord", operatingRecord);
        $A.createComponents([
                ["c:LC_WorkExperienceEditorCmp", {record:operatingRecord, isProjectExperience:component.get("v.isProjectExperience")}],
                ["lightning:button",{label:"Save", variant:"brand", class:"slds-m-horizontal--large slds-float_left", onclick:component.getReference("c.saveExperience")}],
                ["lightning:button",{label:"Cancel", class:"slds-m-horizontal--large slds-float_right", onclick:component.getReference("c.cancelModel")}]
            ],
           function(components, status) {
               if (status === "SUCCESS") {
                    var footerBody = [components[1],components[2]];
                    component.set("v.editor", components[0]);
                    component.find('overlayLib').showCustomModal({
                       header: "项目经验信息录入",
                       body: components[0],
                       showCloseButton: true,
                       footer: footerBody,
                       cssClass: "editordialog",
                       closeCallback: function() {LC_WorkExperienceEditorCmp

                       }
                   });

               }
           }
        );
    },

    updateExperiences : function(component, operatingRecord) {
        var experiences = component.get("v.partList");
        console.log("experiences------>" + JSON.stringify(experiences));

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

        component.set("v.partList", experiences);
        console.log("1111111--->" + JSON.stringify(experiences));
        //this.setRecordType(component);
        this.saveWorkExperience(component, experiences);
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

    saveWorkExperience : function (component, workExperiences) {
       var employeeId = component.get("v.employeeId");
       var recordType = component.get("v.recordType");
       console.log("recordType======201" + JSON.stringify(recordType));
       let action = component.get("c.updateExperiencesList");
    
        action.setParams({
            "experienceList": JSON.stringify(workExperiences),
            "employeeId" : employeeId,
            "recordType" : 'Project_Experience'
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log("result---210--->" + JSON.stringify(result));
                alert("保存成功");
                component.set("v.partList", result);
            } else {
                console.info("Failed with state: " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    /*setRecordType : function (component) {
        let projectExperience = component.get("v.isProjectExperience");
        if (projectExperience == true) {
            component.set("v.RecordType", 'Project_Experience');
        }
    }*/
})