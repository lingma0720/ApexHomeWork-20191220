/**
 * 2019/1/7  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 */

({
    getValue : function(component, event, helper) {
        return helper.getFieldValues(component);
    },
    validate: function(component, event, helper) {

        var inputDelegateCmps = component.find("input-cmp");
        if(!$A.util.isEmpty(inputDelegateCmps)){

            if($A.util.isArray(inputDelegateCmps)){
                return inputDelegateCmps.reduce(function(prev, cmp){
                    if(typeof cmp.checkValidity == 'function'){
                        return prev && cmp.checkValidity();
                    }else{
                        return prev;
                    }
                });
            }else{
                if(typeof inputDelegateCmps.checkValidity == 'function'){
                    return inputDelegateCmps.checkValidity();
                }else{
                    return true;
                }
            }
        }
    },
})