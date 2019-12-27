public  class SendMessageUtil {

    public static void sendEmail(Contact targectContact) {
    		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		    email.setSenderDisplayName('Ma Lingling');
		    email.setPlainTextBody('The Case of Your Account has closed');
		    email.setSubject('Case Status has Changed');
		    email.setTargetObjectId(targectContact.Id);
		    email.setSaveAsActivity(false);
        	Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {email});
    	}
	}