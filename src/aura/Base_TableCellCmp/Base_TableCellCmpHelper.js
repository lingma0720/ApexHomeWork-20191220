/**
 * Created by meixing on 2019-05-08.
 */
({
    initCellBody : function(component, data, column){
        var helper = this;

        if(data && column){
            var columnValue = helper.getColumnValue(data, column.name),
                components = [];

            if (column.options && column.options.clickable === true) {
                components.push({
                    componentType: 'lightning:button',
                    componentAttribute: {
                        label: columnValue,
                        title: columnValue,
                        class: 'cap-btn-hyperlink',
                        onclick: component.getReference("c.triggerClickable")
                    }
                });
            } else {
                switch(column.type){
                    case 'string': {
                        components.push({
                            componentType: 'lightning:formattedText',
                            componentAttribute: {value: columnValue, title: columnValue}
                        });
                        break;
                    }
                    case 'textarea':{
                        components.push({
                            componentType: 'lightning:formattedRichText',
                            componentAttribute: {value: columnValue, readonly: true}
                        });
                        break;
                    }

                    case 'picklist': {
                        var picklistLabel = helper.getPicklistLabel(columnValue, column.picklistValues);
                        components.push({
                            componentType: 'lightning:formattedText',
                            componentAttribute: {value: picklistLabel, title: columnValue}
                        });
                        break;
                    }
                    case 'integer': {
                        components.push({
                            componentType: 'lightning:formattedNumber',
                            componentAttribute: {value: columnValue, title: columnValue}
                        })
                        break;
                    }
                    case 'double': {
                        components.push({
                            componentType: 'lightning:formattedNumber',
                            componentAttribute: {value: columnValue, title: columnValue, minimumFractionDigits: 2, maximumFractionDigits: 2}
                        })
                        break;
                    }
                    case 'byte': {
                        var convertedFileSize = helper.bytesToSize(columnValue);
                        components.push({
                            componentType: 'lightning:formattedText',
                            componentAttribute: {value: convertedFileSize, title: convertedFileSize}
                        })
                        break;
                    }
                    case 'date': {
                        components.push({
                            componentType: 'ui:outputDate',
                            componentAttribute: {value: columnValue}
                        })
                        break;
                    }
                    case 'datetime': {
                        components.push({
                            componentType: 'ui:outputDateTime',
                            componentAttribute: {value: columnValue}
                        })
                        break;
                    }
                    case 'action': {
                        for (var i = 0; i < column.actions.length; i ++) {
                            var actionConfig = column.actions[i];
                            components.push({
                                componentType: 'lightning:buttonIcon',
                                componentAttribute: actionConfig
                            })
                        }
                        break;
                    }
                    case 'reference': {
                        var linkId = helper.getReferenceId(data, column.name);
                        var attribute = {
                                            label: columnValue,
                                            tooltip: columnValue,
                                            value: '/' + linkId,
                                            target: ''
                                        };
                        if(!$A.util.isEmpty(columnValue)){
                            components.push({
                                componentType: 'lightning:formattedUrl',
                                componentAttribute: attribute
                            });
                        }
                        break;
                    }
                    case 'component': {
                        var attribute = JSON.parse(JSON.stringify(column.componentAttribute));
                        var name = data[column.key]+':'+column.componentAttribute['name'];
                        attribute.name = name;
                        attribute.onclick = component.getReference("c.clickAction");
                        //console.log(JSON.stringify(attribute));

                        components.push({
                            componentType: column.componentName,
                            componentAttribute: attribute
                        });

                        break;
                    }
                    case 'components' : {
                        var list_cmps = column.list_cmps;

                        for (var i = 0; i < list_cmps.length; i++) {
                            var item = list_cmps[i];
                            var attribute = JSON.parse(JSON.stringify(item.componentAttribute));
                            var name = data[item.key]+':'+item.componentAttribute['name'];

                            if (!$A.util.isEmpty(data.cmpStates) && !data.cmpStates[item.componentAttribute['name']]) {
                                continue;
                            }

                            attribute.name = name;
                            attribute.onclick = component.getReference("c.clickAction");

                            components.push({
                                componentType: item.componentName,
                                componentAttribute: attribute
                            });

                        }

                        break;
                    }
                    case 'input': {
                        var attribute = JSON.parse(JSON.stringify(column.componentAttribute));
                        attribute[column.keyAttribute] = data[column.key];
                        attribute['aura:id'] = 'input-tag';
                        //attribute.onclick = component.getReference("c.inputClickAction");
                        attribute.onchange = component.getReference("c.changeAction");
                        if(!$A.util.isEmpty(attribute)){
                            components.push({
                                componentType: column.componentName,
                                componentAttribute: attribute
                            });
                        }
                        break;
                    }
                    default:
                        break;
                }
            }

            if(components && components.length) {
                helper.createComponents(component,components);
            }
        }
    },
    createComponents : function(component,components){
        component.set("v.body", []);
        var list_cmps = components.reduce(function(prev, item){
                            var componentItem = [];
                            componentItem.push(item.componentType);
                            componentItem.push(item.componentAttribute);
                            prev.push(componentItem);
                            return prev;
                        },[]);
        if(!$A.util.isEmpty(list_cmps)){
            $A.createComponents(
                list_cmps,
                function(content, status, errorMessage){
                    if (status === "SUCCESS") {
                        component.set("v.body", content);
                    }
               }
            );
        }
    },
    getReference : function(data, referencePath){

        var referFields = referencePath.split('.'),
        counter = 0,
        loopData = JSON.parse(JSON.stringify(data));

        while (counter < referFields.length) {
            var field = referFields[counter];
            loopData = loopData[field];
            counter ++;
            if (!loopData) break;
        }
        return loopData;
    },

    getReferenceId: function(data, referencePath){
        if (referencePath.indexOf('.') === -1) return data[referencePath];

        var referFields = referencePath.split('.');
        referFields.splice(referFields.length - 1, 1);

        // try to load from related object
        var fixedFieldPath = referFields.join('.') + '.Id';
        var columnValue = this.getColumnValue(data, fixedFieldPath);

        if (columnValue) return columnValue;

        // try to load from record itself
        var lastField = referFields[referFields.length - 1];
        if (lastField.substr(-3) === '__r') {
            lastField = lastField.substr(0, lastField.length - 3) + '__c'
        } else {
            lastField += 'Id';
        }
        referFields[referFields.length - 1] = lastField;
        var fixedFieldPath = referFields.join('.');

        return this.getColumnValue(data, fixedFieldPath);
    },

    getColumnValue: function (data, fieldPath) {
        if (!data || !fieldPath) return '';

        if (fieldPath.indexOf('.') === -1) {
            return data[fieldPath];
        }

        var referFields = fieldPath.split('.'),
        counter = 0,
        loopData = JSON.parse(JSON.stringify(data));

        while (counter < referFields.length) {
            var field = referFields[counter];
            loopData = loopData[field];
            counter ++;
            if (!loopData) break;
        }
        return loopData;
    },

    getPicklistLabel: function (value, picklists) {
        if (value && picklists && picklists.length) {
            for (var i = 0; i < picklists.length; i ++) {
                if (picklists[i].value === value) {
                    return picklists[i].label;
                }
            }
        } else {
            return '';
        }
    },

    bytesToSize: function(bytes) {
        if (!bytes) return '0 B';
        var k = 1024,
            sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
            i = Math.floor(Math.log(bytes) / Math.log(k));

       return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
    },

    getAttributeKey: function(column, actionType){
        var list_cmps = column.list_cmps;
        var key;

        for (var i = 0; i < list_cmps.length; i++) {
            var item = list_cmps[i];

            if(item.componentAttribute.name === actionType){
                key = item.key;
                break;
            }
        }

        return key;
    },
})