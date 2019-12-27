@isTest
public with sharing class ClsService_Picklist_Test {
    static testMethod void test_getEntries() {
        
        List<Map<String,String>> picklistEntry_List = ClsService_Picklist.getEntries('Account', 'AccountSource');
        Boolean result = false;
        for (Map<String,String> obj : picklistEntry_List) {
        	if (obj.get('label') == 'Web') {
        		result = true;
        	}
        }
        System.assertEquals(true, result);
        

    }

    static testMethod void test_getDependentEntries() {
        
           Map<String, List<Map<String,String>>> result_Map = ClsService_Picklist.getDependentEntries('Account', 'Province__c', 'City__c'); 
        
    }

}