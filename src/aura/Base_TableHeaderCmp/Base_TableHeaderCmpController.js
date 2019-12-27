/**
 * Created by meixing on 2019-05-08.
 */
({
    handleColumnHeaderClick : function(component, event, helper) {
        var columnName = component.get("v.column").name;
        var columnType = component.get("v.column").type;
        var currentSortColumn = component.get("v.currentSortColumn");

        var ascending = component.get("v.ascending");

        if(columnName != currentSortColumn){
            ascending = false;
        }

        var compEvent = component.getEvent("sort");
        compEvent.setParams({
            "columnName": columnName,
            "columnType": columnType,
            "isSortedAsc" : !ascending
        });
        compEvent.fire();

        component.set("v.ascending", !ascending)
    },
    doInit : function(component, event, helper) {
        var column = component.get("v.column");

        if(column.headerEvent){
           helper.initCellBody(component, column);
        }
    },
    changeAction : function(component, event, helper) {
        var column = component.get("v.column");
        var attributeValue = event.getSource().get("v."+column.keyAttribute);

        var compEvent = component.getEvent("columnEvent");
        compEvent.setParams({
            "type": 'columnEvent',
            "message": '',
            "data" : {column: column.key, value: attributeValue}
        });
        compEvent.fire();

    },
})