@IsTest
private class FieldDefinition_Test {
    @IsTest
    static void testBehavior() {
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

    }
    
}