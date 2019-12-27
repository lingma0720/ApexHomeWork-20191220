/**
 * 2018/10/15  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 */


({

    onOptionClick : function(component, event, helper) {
        var optionValue = event.currentTarget.id;
        helper.updateOptions(component, optionValue);

        helper.resetFocus(component);
    },

    onFocus : function(component, event, helper) {
        component.set('v.hasFocus', true);
    },

    onBlur : function(component, event, helper) {
        // Delay hiding combobox so that we can capture selected result
        component.blurTimeout = window.setTimeout(
            $A.getCallback(function(){
                component.set('v.hasFocus', false);
            }),
            300
        );

    },
    onSrcoll : function(component, event, helper) {
    	helper.resetFocus(component);
    },
    onSelectAll : function(component, event, helper){
        helper.toggleAllOptions(component);
    },
    hideListbox: function(component, event, helper) {
        var listId = component.getGlobalId() + '_listbox';
        if(event.currentTarget.id === listId){
            component.set('v.hasFocus', false);
        }
    },
    refreshState: function(component, event, helper) {

        //console.log('refreshState In');

        if (!helper.hasInitializedWithDefault(component)) {
        	helper.initSelectedState(component);
        }

        helper.setDisplayValue(component);
    },
    handleOptionChanged: function(component, event, helper) {

        //console.log('handleOptionChanged In');

        helper.initSelectedState(component);

        helper.setDisplayValue(component);
    },
})