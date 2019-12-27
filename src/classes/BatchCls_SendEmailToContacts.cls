global  class BatchCls_SendEmailToContacts implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
		//Datetime today = Datetime.now().addDays(3);
		Datetime sendEmailDate = Datetime.now();
		String query = 'SELECT Id, ' +
			' Owner.Email, ' +
			' Priority, ' +
			' Status, ' +
			' CreatedDate ' +
			' FROM Case  ' +
			' WHERE  Status = \'New\' ' +
			' AND Priority = \'High\' ' ;
		System.debug('query---->'+query);
		return Database.getQueryLocator(query);
	}


	global void execute(Database.BatchableContext BC, List<SObject> listObj) {
		Set<Id> sendCaseOwnerIds = new Set<Id>();
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		EmailTemplate theCaseNeedToSolveQuickly = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName  = :'Need_to_Solve_Case_Quickly_Template'
	                                           LIMIT 1];

        System.debug('theCaseNeedToSolveQuickly' + theCaseNeedToSolveQuickly);

		for (SObject caseObj : listObj) {
			Case sendEmailCase = (Case) caseObj;
			System.debug('sendEmailCase-------->' + sendEmailCase);
			sendCaseOwnerIds.add(sendEmailCase.Owner.Id);
			System.debug('sendCaseOwnerIds------>' + sendCaseOwnerIds);
		}

		if (sendCaseOwnerIds.size() < 0) {
			return;
		}

		/*Map<Id, Case> sendEmailCaseOwners = new Map<Id, Case>([SELECT Id, OwnerId, Owner.Email FROM Case WHERE OwnerId IN : sendCaseOwnerIds]);
		System.debug('sendEmailCaseOwners--------->' + sendEmailCaseOwners);*/

		for (SObject caseObj : listObj) {
			Case  sendEmergencyCase = (Case) caseObj;
			System.debug('sendEmergencyCase------->' + sendEmergencyCase);
			String sendEmail = sendEmergencyCase.Owner.Email;
			System.debug('sendEmail-------********' + sendEmail);
			Messaging.SingleEmailMessage caseNotificationmail = new Messaging.SingleEmailMessage();
			caseNotificationmail.setSenderDisplayName('Salesforce');
            caseNotificationmail.setTargetObjectId(sendEmergencyCase.OwnerId);
            caseNotificationmail.setSaveAsActivity(false);
           //caseNotificationmail.setWhatId(sendEmergencyCase.Id);
            caseNotificationmail.setTemplateId(theCaseNeedToSolveQuickly.Id);
            caseNotificationmail.setToAddresses(new List<String> {sendEmail});
            mails.add(caseNotificationmail);
		}

		Messaging.sendEmail(mails);

	}

	global void finish(Database.BatchableContext bc) {
	}
}