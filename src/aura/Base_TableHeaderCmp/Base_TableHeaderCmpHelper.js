/**
 * Created by meixing on 2019-05-08.
 */
({
    initCellBody : function(component, column){
        var helper = this;
        var components = [];

        switch(column.type){
            case 'input': {
                var attribute = JSON.parse(JSON.stringify(column.componentAttribute));
                attribute['aura:id'] = 'input-tag';
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

        if(components && components.length) {
            helper.createComponents(component,components);
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
})