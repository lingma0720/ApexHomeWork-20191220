/**
 * Created by meixing on 2019-05-08.
 */
({
    onTableRowClick : function(component, event, helper){
        //console.log('onClick In');
        var data = {
            rowIndex : component.get('v.rowIndex')
        }
        var cmpEvt = component.getEvent("TableRowFocus");
        cmpEvt.setParams({
            "data" : data
        });
        cmpEvt.fire();
    },
    setActive : function(component, event, helper){
        component.set('v.active', event.getParam('arguments').active);
    },
})