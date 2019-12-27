/**
 * Created by meixing on 2019-10-04.
 */
({
    handleTableRowFocus : function(component, event, helper) {
        var data = event.getParam('data');
        if(data){
            var records = component.get('v.records');
            //console.log('rowIndex:::' + data.rowIndex);
            var rows = component.find('table-rows');
            if(!$A.util.isEmpty(rows)){
                if($A.util.isArray(rows)){
                    rows.forEach(function(item, index){
                        if(index === data.rowIndex){
                            item.setActive(true);
                        }else{
                            item.setActive(false);
                        }
                    });
                }else{//object, only one row
                    //var row = rows;
                }
            }
        }
    },
})