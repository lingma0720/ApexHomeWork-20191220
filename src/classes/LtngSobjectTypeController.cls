/**
 * This class provides a set of aura enable methods for SObject Type service component
 *
 @author  Zhuoxue Jin
 @created 08/10/2018
 @version 1.0
 @since   43.0 (Force.com ApiVersion)
 *
 @changelog
 * 08/10/2018  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 */
public with sharing class LtngSobjectTypeController {

    /**
      * This method used to retrieve the Sobject field definition via the specified SObjectType and Field Name.
      *
      @param objectName	    String	    Specifies the SObjectType token to retrieve
      @param fieldNames	    List	    Specifies a list of field name to retrieve
      @return Map<String, Map<String,String>> A map including the mapping relation between field name and field definition
      @author Jacob Jin
      @created 2018-08-21
      **/
    @AuraEnabled
    public static Map<String, FieldDefinition> getFieldsMap(String objectName, List<String> fieldNames) {

        Map<String, FieldDefinition>results = new Map<String, FieldDefinition>();

        if(String.isEmpty(objectName) || (fieldNames == null || fieldNames.isEmpty()))
            return results;

        //Get the ClsSObjectDescribe instance
        ClsSObjectDescribe sObjectDescribe = ClsSObjectDescribe.getDescribe(objectName);

        ClsSObjectDescribe.FieldsMap allFieldsMaps = sObjectDescribe.getFields();

        for(String fieldName : fieldNames){
            if(allFieldsMaps.get(fieldName) != null){

                results.put(fieldName, new FieldDefinition(allFieldsMaps.get(fieldName).getDescribe()));
            }
        }

        System.debug('=========>:' + results);

        return results;
    }
}