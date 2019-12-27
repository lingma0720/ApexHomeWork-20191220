({
	validateDate : function(component) {
		var startDate = component.get('v.startDate');
		var endDate = component.get('v.endDate');
		if(!$A.util.isEmpty(startDate) && !$A.util.isEmpty(endDate)){
			if(startDate > endDate){
				component.set('v.hasError', true);
			}else{
				component.set('v.hasError', false);
			}
		}else{
			component.set('v.hasError', false);
		}
	}
})