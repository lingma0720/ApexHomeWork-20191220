@isTest
private class BatchCls_SendEmailToContactsTest {
    
    static testMethod void testCaseNotificationBatch() {

    	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
		User caseOwner = new User(Alias = 'lumi', Email='1059963622@qq.com', 
		                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
		                    LocaleSidKey='en_US', ProfileId = p.Id, 
		                    TimeZoneSidKey='America/Los_Angeles', UserName='1059963622mll@qq.com');
		insert caseOwner;

        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < 200; i++) {
        	Case c = new Case( Status = 'New', Priority = 'High', OwnerId = caseOwner.Id);
        	caseList.add(c);
        }
        insert caseList;

        Test.startTest();
        BatchCls_SendEmailToContacts sendEmail = new BatchCls_SendEmailToContacts();
        Id batchProcessIds = Database.executeBatch(sendEmail);
        Test.stopTest();

        System.assertEquals(database.countquery('SELECT COUNT()'
                            +' FROM Case WHERE Owner.Id=\'' + caseOwner.Id + '\''), 200);
    }
}