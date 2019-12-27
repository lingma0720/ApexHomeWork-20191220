({
    updateSearchTerm : function(component, searchTerm) {
        // Cleanup new search term
        var updatedSearchTerm = searchTerm.trim().replace(/\*/g).toLowerCase();

        // Compare clean new search term with current one and abort if identical
        var curSearchTerm = component.get('v.searchTerm');
        if (curSearchTerm === updatedSearchTerm) {
            return;
        }

        // Update search term
        component.set('v.searchTerm', updatedSearchTerm);

        // Ignore search terms that are too small
        if (updatedSearchTerm.length < 2) {
            component.set('v.searchResults', []);
            return;
        }

        // Apply search throttling (prevents search if user is still typing)
        var searchTimeout = component.get('v.searchThrottlingTimeout');
        if (searchTimeout) {
            clearTimeout(searchTimeout);
        }
        searchTimeout = window.setTimeout(
            $A.getCallback(function(){
                // Send search event if it long enougth
                var searchTerm = component.get('v.searchTerm');
                if (searchTerm.length >= 2) {
                    var searchEvent = component.getEvent('onSearch');
                    searchEvent.fire();
                }
                component.set('v.searchThrottlingTimeout', null);
            }),
            300
        );
        component.set('v.searchThrottlingTimeout', searchTimeout);
    },

    selectResult : function(component, recordId) {
        // Save selection
        var searchResults = component.get('v.searchResults');
        var selectedResult = searchResults.filter(function(result){ return result.id === recordId});
        if (selectedResult.length > 0) {
            var selection = component.get('v.selection');
            selection.push(selectedResult[0]);
            component.set('v.selection', selection);
        }
        // Reset search
        var searchInput = component.find('searchInput');
        searchInput.getElement().value = '';
        component.set('v.searchTerm', '');
        component.set('v.searchResults', []);
    },

    getSelectedIds : function(component) {
        var selection = component.get('v.selection');
        return selection.map(function(element) { return element.id });
    },

    removeSelectedItem : function(component, removedItemId) {
        var selection = component.get('v.selection');
        var updatedSelection = selection.filter(function(item){ return item.id !== removedItemId});
        component.set('v.selection', updatedSelection);
    },

    clearSelection : function(component, itemId) {
        component.set('v.selection', []);
    },

    isSelectionAllowed : function(component) {
        return component.get('v.isMultiEntry') ||
            	!component.get('v.selection') || component.get('v.selection').length === 0;
    }
})