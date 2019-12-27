({
    close : function(component, event, helper) {
		component.set("v.hiddren", true);
	},
	show : function(component, event, helper) {
		var params = event.getParam('arguments');

        if (params) {
            var content = params.content;

	        var state = params.state;
	        var iconName = 'utility:info';
	        if(state == 'error'){
	            iconName = 'utility:error';
	        }else if(state == 'success'){
	            iconName = 'utility:success';
	        }else if(state == 'warning'){
				iconName = 'utility:warning';
	        }else if(state == 'info'){
	        	iconName = 'utility:info';
	        }

	        if(state){
	        	component.set("v.state", state);
	        }

	        if(iconName){
	        	component.set("v.iconName", iconName);
	        }

	        component.set("v.content", content);
	        component.set("v.hiddren", false);

	        var cb = function() {
                component.set("v.hiddren", true);
            };

            var setTimeOut = 5000;
            if (state=='error') {
            	setTimeOut = 8000;
            }

	        setTimeout($A.getCallback(cb), setTimeOut);
        }
	}
})