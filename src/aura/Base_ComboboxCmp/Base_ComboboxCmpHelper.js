/**
 * 2018/10/15  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 * - Modified by Zhuoxue on 20181225 : using cloned options instead of origin options
 */

({
    setDisplayValue : function(component){
        var helper = this;
        var options = component.get('v.clonedOptions');

        var selection = helper.getSelectedValues(options);

        if(selection.length === options.length){
            component.set('v.selectAll', true);
        }else{
            component.set('v.selectAll', false);
        }

        var valueSeparator = component.get('v.valueSeparator');
        var displayFormat = component.get('v.displayFormat');
        if(displayFormat === 'label-detail'){
            component.set('v.displayValue', helper.getSelectedLabels(options).join(valueSeparator));
        }else {
            component.set('v.displayValue', helper.getSelectedValues(options).length + ' items selected');
        }
    },
    updateOptions : function(component, optionValue) {
        var helper = this;
        // Save selection
        var options = component.get('v.clonedOptions');
        var valueSeparator = component.get('v.valueSeparator');
        //console.log('options ==> ' + JSON.stringify(options));

        for(var i=0; i<options.length; i++){
            if(options[i].value === optionValue){
                options[i].selected = !!!options[i].selected;
                break;
            }
        }
        var selection = helper.getSelectedValues(options);

        if(selection.length === options.length){
            component.set('v.selectAll', true);
        }else{
            component.set('v.selectAll', false);
        }

        component.set('v.value', selection.join(valueSeparator));
        component.set('v.clonedOptions', options);

        var changeEvent = component.getEvent('onchange');
        if(changeEvent) {
        	changeEvent.fire();
        }
    },
    getSelectedValues : function(options) {
        if($A.util.isEmpty(options)) return [];

        return options.reduce(function(prev, item){
            if(item.selected ) prev.push(item.value);
            return prev;
        },[]);
    },
    getSelectedLabels : function(options) {
        if($A.util.isEmpty(options)) return [];

        return options.reduce(function(prev, item){
            if(item.selected ) prev.push(item.label);
            return prev;
        },[]);
    },
    /*clearOptions  : function(options) {
        if($A.util.isEmpty(options)) return [];

        return options.reduce(function(prev, item){
            if(item.selected ) prev.push(item.value);
            return prev;
        },[]);
    },*/
    hasInitializedWithDefault: function (component) {
    	var globalId = 'init-state-' + component.getGlobalId();
    	return this[globalId] && this[globalId] === true;
    },
    setInitializedWithDefault: function (component) {
    	var globalId = 'init-state-' + component.getGlobalId();
    	this[globalId] = true;
    },
    initSelectedState: function (component) {
        var helper = this;

    	var options = component.get('v.options');
		var value = component.get('v.value');
		var valueSeparator = component.get('v.valueSeparator');



        //console.log('initSelectedState In', options, value);
        /*console.log('initSelectedState In', options, value);
        var values = value ? value.split(valueSeparator) : [];

        options = options.map(function(item){
            item.selected = values.includes(item.value);
            return item;
        });*/

        var clonedOptions = helper.resolveClonedOptions(options, value, valueSeparator);

        if(!$A.util.isEmpty(clonedOptions)){
            this.setInitializedWithDefault(component);
            component.originOptions = options;
            component.set('v.clonedOptions', JSON.parse(JSON.stringify(clonedOptions)));
        }else{
            component.set('v.clonedOptions', []);
        }

        //console.log('initSelectedState Finish', options, value);

    },

    resetFocus : function (component) {
    	// If the option is clicked , cancel the action to combobox
    	if (component.blurTimeout ) {
            clearTimeout(component.blurTimeout );
            component.blurTimeout = null;
        }

        var comboboxId = component.getGlobalId() + '_combobox';
        document.getElementById(comboboxId).focus();
    },
    resolveClonedOptions: function(originOptions, value, valueSeparator) {
        // Remove the properties that not including in originOptions from clonedOptions
        var values = value ? value.split(valueSeparator) : [];

        return originOptions.reduce(function(prev, item){
            item.selected = values.includes(item.value);
            prev.push(item);

            return prev;
        },[]);
    },
    toggleAllOptions : function (component) {
        var helper = this;

        var selectAll = component.get('v.selectAll');

        var options = component.get('v.clonedOptions');
        var valueSeparator = component.get('v.valueSeparator');

        for(var i=0; i<options.length; i++){
            options[i].selected = !!!selectAll;
        }
        var selection = helper.getSelectedValues(options);

        component.set('v.selectAll', !!!selectAll);
        component.set('v.value', selection.join(valueSeparator));
        component.set('v.clonedOptions', options);

        var changeEvent = component.getEvent('onchange');
        if(changeEvent) {
            changeEvent.fire();
        }

        helper.resetFocus(component);
    },
})