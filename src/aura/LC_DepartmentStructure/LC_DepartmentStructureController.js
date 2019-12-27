/**
 * Created by meixing on 2019-10-05.
 */
({
    getDepartmentStructure : function(component, event, helper) {
        helper.setDepartmentStructure(component);
        helper.setColumns(component);
    },

    handleRowAction : function(component, event, helper) {
        var params = event.getParams();

        switch(params.type){
            case 'expand' : {
                if(params.data.status){
                    helper.getSubData(component);
                }
                break;
            }

            default : {
                //console.log('unhandled action:' + params.type);
            }
        }
    }
})