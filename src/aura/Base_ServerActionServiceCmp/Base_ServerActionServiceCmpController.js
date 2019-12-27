({
	invokeAction : function(component, event, helper) {
		var params = event.getParam('arguments');

		return helper.enqueueAction(component, params && params.serverAction);
	}
})