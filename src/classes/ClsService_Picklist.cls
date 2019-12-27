/**
 * This class provides a set of utility functions for accessing Picklist Entry.
 *
 @author  
 @created 2019-05-07
 @version 1.0
 @since   43.0 (Force.com ApiVersion)
 *
 @changelog
 * 2019-05-07  
 * - Created
 */

public class ClsService_Picklist {

    /*
    * This inner class contains the attribute to init the components
    */
    public class CustomPicklistEntry {
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public Map<String, CustomPicklistEntry> subEntries;
    }

    /**
     * This method used to convert the picklist entries to List<Map<String,String>> .
     *
     @param picklistEntries	List<Schema.PicklistEntry>	Specifies the picklist entries to be converted
     @return List<Map<String,String>> A list of the definition of picklist entry
     @author Jacob Jin
     @created 2018-08-21
     **/
    public static List<Map<String,String>> convertEntries(List<Schema.PicklistEntry> picklistEntries){
        List<Map<String,String>> activeEntries = new List<Map<String,String>>();

        for(Schema.PicklistEntry entry : picklistEntries) {
            if (entry.isActive()) {
                Map<String,String> entryData = new Map<String,String>();
                entryData.put('value', entry.getValue());
                entryData.put('label', entry.getLabel());
                entryData.put('isDefaultValue', String.valueOf(entry.isDefaultValue()));
                activeEntries.add(entryData);
            }
        }
        return activeEntries;
    }

    /**
     * This method used to retrieve the picklist entries via the specified SObjectType and Field Name.
     *
     @param objectName	String	Specifies the SObjectType to retrieve
     @param fieldName	String	Specifies the Field Name to search.
     @return List<Map<String,String>> A list of the definition of picklist entry
     @author Jacob Jin
     @created 2018-08-21
     **/
    public static List<Map<String,String>> getEntries(String objectName, String fieldName) {
        // Get entries from object and field names
        List<Schema.PicklistEntry> allEntries;
        try {

            Schema.SObjectField field = ClsSObjectDescribe.getDescribe(objectName).getField(fieldName);
            if (field == null) {
                throw new PicklistServiceException('No such field.');
            }

            Schema.DescribeFieldResult fieldDescription = field.getDescribe();
            allEntries = fieldDescription.getPicklistValues();

        } catch (Exception e) {
            throw new PicklistServiceException('Failed to retrieve entries for picklist '+ objectName +'.'+ fieldName +': '+ e.getMessage());
        }

        // Filter active entries and convert output (AuraEnabled methods cannot return List<Schema.PicklistEntry>)

        return convertEntries(allEntries);
    }

    /**
     * This method used to retrieve the picklist entries via the specified SObjectType and Field Name.
     *
     @param objectType	        String	Specifies the SObjectType to retrieve
     @param controllingField	String	Specifies the Controlling Field Name.
     @param dependentField	    String	Specifies the Dependent Field Name.
     @return Map<String, List<Map<String,String>>> A map including the mapping relation between the value of controlling
     field and the available dependent picklist entries
     @author Jacob Jin
     @created 2018-08-21
     **/
    public static Map<String, List<Map<String,String>>> GetDependentEntries(String objectType,
            String controllingField,
            String dependentField){
        ClsSObjectDescribe describe = ClsSObjectDescribe.getDescribe(objectType);

        return ClsService_Picklist.GetDependentEntries(describe.getSObjectType(),
                describe.getField(controllingField),
                describe.getField(dependentField));
    }

    /**
     * This method used to retrieve the picklist entries via the specified SObjectType and Field Name.
     *
     @param objectType	        SObjectType	Specifies the SObjectType token to retrieve
     @param controllingField	SObjectField	Specifies the Controlling Field token.
     @param dependentField	    SObjectField	Specifies the Dependent Field token.
     @return Map<String, List<Map<String,String>>> A map including the mapping relation between the value of controlling
     field and the available dependent picklist entries
     @author Jacob Jin
     @created 2018-08-21
     **/
    public static Map<String, List<Map<String,String>>> GetDependentEntries(Schema.SObjectType objectType,
            Schema.SObjectField controllingField,
            Schema.SObjectField dependentField){
        if(objectType == null || controllingField == null || dependentField==null)
            throw new PicklistServiceException('No such field: '+ objectType +'.'+ controllingField +' or ' + objectType +'.'+ dependentField );

        Map<String,List<Map<String,String>>> results = new Map<String,List<Map<String,String>>>();
        ClsBitset bitSetInstance = new ClsBitset();

        //cache the controlling picklist entries
        List<Schema.PicklistEntry> ctrlPicklistEntries = controllingField.getDescribe().getPicklistValues();
        //cache the dependent picklist entries
        List<Schema.PicklistEntry> depPicklistEntries= dependentField.getDescribe().getPicklistValues();

        List<Integer> listControllingIndexes = new List<Integer>();

        //iterate through the controlling picklist entries and init the dependent entry list valid for the controlling field
        for(Integer iPos=0; iPos < ctrlPicklistEntries.size(); iPos++){
            //get the controlling picklist entry
            Schema.PicklistEntry ctrlPicklistEntry = ctrlPicklistEntries[iPos];
            //get the value of entry
            String ctrlValue = ctrlPicklistEntry.getValue();
            //init the dependent entry list with the value
            results.put(ctrlValue,new List<Map<String,String>>());
            //keep track of the controlling indexes
            listControllingIndexes.add(iPos);
        }

        //load all dep entries
        List<Schema.PicklistEntry> objEntries = depPicklistEntries.clone();
        List<Map<String,String>> objDeptEntries = (List<Map<String,String>>)JSON.deserialize(JSON.serialize(objEntries), List<Map<String,String>>.class);

        List<Integer> validIndexes;
        for (Map<String,String> deptEntry : objDeptEntries){
            //if valid for is empty, skip
            if (String.isEmpty(deptEntry.get('validFor'))){
                continue;
            }

            //do test bits for the controlling Picklist Entry
            for (Integer validIndex : bitSetInstance.testBits(deptEntry.get('validFor'),listControllingIndexes)){
                //get the label
                String ctrlValue = ctrlPicklistEntries[validIndex].getValue();
                results.get(ctrlValue).add(deptEntry);
            }
        }

        return results;

    }

    private class PicklistServiceException extends Exception {}
}