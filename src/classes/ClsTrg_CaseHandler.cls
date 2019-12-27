public class ClsTrg_CaseHandler extends ClsTriggerVirtual {
   
/**
     * @see IntHelper.beforeTrigger
     */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        for (SObject sobj : trgCtx.newList) {
            Case newCase = (Case) sobj;
        }
        sendEmailTOContacts(trgCtx);

    }
    public static  void sendEmailTOContacts(ClsWrappers.TriggerContext trgCtx) {
       if (trgCtx.isInsert || trgCtx.isUpdate) {
            Set<Id> conId = new Set<Id>();
            EmailTemplate caseStatusChanged = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName  = :'Case_Closed_Notification_Template'
                                               LIMIT 1];

            System.debug('caseStatusChanged' + caseStatusChanged);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Map<Id, sObject> oldCases = trgCtx.oldMap;
            System.debug('oldCases------>' + oldCases);
            for (Case newcase : (List<Case>)trgCtx.newList) {
                System.debug('newcases------>' + newcase);
                if (newcase.Status == 'Closed') {
                    if (oldCases != null) {

                        Case caseOld = (Case) oldCases.get(newcase.Id);
                        if (caseOld.Status != 'Closed') {
                            conId.add(newcase.ContactId);
                        }
                    }


                     else {
                        conId.add(newcase.ContactId);
                        System.debug('conId------>' + conId);
                    }
                }
            }

            //如果新建的case不符合条件,直接返回，不需要发送电子邮件
            if (conId.size() == 0) {
                return;
            }

            Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, Email, IsMainManger__c, Name FROM Contact WHERE Id In :conId AND IsMainManger__c = true]);

            for (Case caseNew : (List<Case>)trgCtx.newList) {
                Contact relatedCaseContact = conMap.get(caseNew.ContactId);
                System.debug('Contact--------->' + relatedCaseContact);
                Messaging.SingleEmailMessage caseNotificationmail = new Messaging.SingleEmailMessage();
                caseNotificationmail.setSenderDisplayName('Salesforce');
                caseNotificationmail.setTargetObjectId(relatedCaseContact.Id);
                caseNotificationmail.setSaveAsActivity(false);
                caseNotificationmail.setWhatId(caseNew.Id);
                caseNotificationmail.setTemplateId(caseStatusChanged.Id);
                caseNotificationmail.setToAddresses(new List<String> { relatedCaseContact.Email });
                /*caseNotificationmail.setToAddresses(new List<String> { relatedCaseContact.Email });
                caseNotificationmail.setSubject('About Case Status');
                caseNotificationmail.setPlainTextBody('your case has closed');*/
                mails.add(caseNotificationmail);
            }
            Messaging.sendEmail(mails);
        }

    }
}