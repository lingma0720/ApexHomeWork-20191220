public with sharing class LC_EmployeeController {
	@AuraEnabled
    public static List<Employee__c> getEmployeeDetails(String employeeId) {
        List<Employee__c> results = [SELECT Id, SelfDescription__c, SkillDescription__c FROM Employee__c 
                                     WHERE Id = : employeeId];
        return results;
    }


    @AuraEnabled
    public static List<Experience__c>  updateExperiencesList(String  experienceList, String employeeId, String recordType) {
            System.debug('RecordType----------->' + recordType);
            List<Experience__c> resultList = new List<Experience__c> ();
            List <Experience__c> experienceListUpdate = (List<Experience__c>) System.JSON.deserialize(experienceList, List<Experience__c>.Class);
            System.debug('experienceList---------->' + experienceListUpdate);
            //Employee__c targetEmployee =[SELECT Id, Name FROM Employee__c WHERE Id =: employeeId];
            RecordType targetRecordType = [SELECT Id, DeveloperName FROM RecordType WHERE RecordType.DeveloperName =: recordType];
            for (Experience__c e : experienceListUpdate) {
                e.RelatedTo__c = employeeId;
                e.RecordTypeId = targetRecordType.Id;
            }
            upsert experienceListUpdate; 
            return experienceListUpdate;
       
        
    }
}