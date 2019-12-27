({
    search : function(component, event, helper) {
        var action = event.getParam('arguments').serverAction;

        action.setParams({
            searchTerm : component.get('v.searchTerm')
        });
        action.setStorable(); // Enables client-side cache & makes action abortable

        component.find('baseService')
        		.invoke(action)
        		.then($A.getCallback(function(entries){
        		     //console.log(entries);
					 component.set('v.searchResults', entries);
				}),
		        $A.getCallback(function(err) {
		        	//console.error(err);

		        	var toastEvent = $A.get('e.force:showToast');
	                if (typeof toastEvent !== 'undefined') {
	                    toastEvent.setParams({
	                        title : 'Server Error',
	                        message : err,
	                        type : 'error',
	                        mode: 'sticky'
	                    });
	                    toastEvent.fire();
	                }
		        }));
		        /*.catch(err => {
		        	$A.reportError("error message here", err);
		        });*/
    },

    clear : function (component, event, helper) {
    	component.find('searchInput').getElement().value = null;
    },

    onInput : function(component, event, helper) {
        // Prevent action if selection is not allowed
        if (!helper.isSelectionAllowed(component)) {
            return;
        }
        var newSearchTerm = event.target.value;
        helper.updateSearchTerm(component, newSearchTerm);
    },

    onResultClick : function(component, event, helper) {
        var recordId = event.currentTarget.id;
        helper.selectResult(component, recordId);
    },

    onComboboxClick : function(component, event, helper) {
        // Hide combobox immediatly
        var blurTimeout = component.get('v.blurTimeout');
        if (blurTimeout) {
            clearTimeout(blurTimeout);
        }
        component.set('v.hasFocus', false);
    },

    onFocus : function(component, event, helper) {
        // Prevent action if selection is not allowed
        if (!helper.isSelectionAllowed(component)) {
            return;
        }
        component.set('v.hasFocus', true);
    },

    onBlur : function(component, event, helper) {
        // Prevent action if selection is not allowed
        if (!helper.isSelectionAllowed(component)) {
            return;
        }
        // Delay hiding combobox so that we can capture selected result
        var blurTimeout = window.setTimeout(
            $A.getCallback(function(){
                component.set('v.hasFocus', false);
                component.set('v.blurTimeout', null);
            }),
            300
        );
        component.set('v.blurTimeout', blurTimeout);
    },

    onRemoveSelectedItem : function(component, event, helper) {
        var itemId = event.getSource().get('v.name');
        helper.removeSelectedItem(component, itemId);
    },

    onClearSelection : function(component, event, helper) {
        helper.clearSelection(component);
    },
    searchWithFilter : function(component, event, helper) {
        var action = event.getParam('arguments').serverAction;
        var parentId = event.getParam('arguments').parentId;
        var type = event.getParam('arguments').type;
        action.setParams({
            searchTerm : component.get('v.searchTerm'),
            parentId : parentId,
            type : type
        });
        action.setStorable(); // Enables client-side cache & makes action abortable

        component.find('baseService')
                .invoke(action)
                .then($A.getCallback(function(entries){
                     //console.log(entries);
                     component.set('v.searchResults', entries);
                }),
                $A.getCallback(function(err) {
                    //console.error(err);

                    var toastEvent = $A.get('e.force:showToast');
                    if (typeof toastEvent !== 'undefined') {
                        toastEvent.setParams({
                            title : 'Server Error',
                            message : err,
                            type : 'error',
                            mode: 'sticky'
                        });
                        toastEvent.fire();
                    }
                }));
    },
})