({
    doInit : function(component, event, helper) {
        const service = component.find('service');
        let objectAPINameList = ['Account','Contact'];
        let objectFieldAPINameMap = {'Account':['Name','Type']};
        service.getFieldLabel(objectAPINameList,objectFieldAPINameMap,function(result) {
            console.log(JSON.stringify(result));
            component.set('v.accountFieldLabelMap',result['Account']);
            component.set('v.contactFieldLabelMap',result['Contact']);
            console.log(JSON.stringify(result['Account']));
            console.log(JSON.stringify(result.Account));
        });
    }
})