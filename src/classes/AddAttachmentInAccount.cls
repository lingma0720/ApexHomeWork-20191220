/*上传附件 关联到Account*/
public with sharing class AddAttachmentInAccount {
	public String accountId {
		get;
		set;
	}

	public AddAttachmentInAccount() {
		Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'test'];
		accountId = testAccount.Id;
	}

@RemoteAction
	public static String addAttachment(String attachmentName, String attachmentBody, String parentId) {
		String result;
		Attachment attachment = new Attachment();
		attachment.Name = attachmentName;
		attachment.Body = EncodingUtil.base64Decode(attachmentBody);
		attachment.ParentId = parentId;
		try {
			insert attachment;
			result = 'Successfully';	
		} catch(Exception e) {
			result = 'Failed';
		}
		return result;
	}
    
}