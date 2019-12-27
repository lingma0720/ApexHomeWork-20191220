global without sharing class ContactController {
    
    static webservice Boolean changeContactsStatus(List<Contact> contactList) {
        List<Contact> updateContactList = new List<Contact>();
        for(Contact c : contactList) {
            Contact tempContact = new Contact();
            tempContact.Id = c.Id;
            tempContact.Is_Checked__c = true;
            updateContactList.add(tempContact);
        }
        try {
            if(updateContactList.size() > 0) {
                update updateContactList;
            }
            return true;
        } catch(Exception e) {
            return false;
        }
    }
}