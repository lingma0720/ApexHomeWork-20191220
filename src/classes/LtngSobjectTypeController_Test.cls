@isTest
private class LtngSobjectTypeController_Test {
    static testMethod void testFieldsMap() {
        
    	Test.startTest();
    	Map<String, FieldDefinition> results = LtngSobjectTypeController.getFieldsMap('Account', new List<String>{'Province__c'});
    	FieldDefinition statusField = results.get('Province__c');
    	statusField.getByteLength();
    	statusField.getCalculatedFormula();
    	statusField.getController();
    	statusField.getDefaultValue();
    	statusField.getDefaultValueFormula();
    	statusField.getDigits();
    	statusField.getInlineHelpText();
    	statusField.getLabel();
    	statusField.getLength();
    	statusField.getLocalName();
    	statusField.getName();
    	statusField.getPicklistValues();
    	statusField.getPrecision();
    	statusField.getReferenceTargetField();
    	statusField.getRelationshipName();
    	statusField.getRelationshipOrder();
    	statusField.getScale();
    	String type = statusField.getType();
    	System.assertEquals('picklist', type);
    	Test.stopTest();
        
    }
}