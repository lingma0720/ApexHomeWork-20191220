public with sharing class AccountSharing extends ClsTriggerVirtual{

    /**
     * @see IntHelper.beforeTrigger
     */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        for (SObject sobj : trgCtx.newList) {
            Account newAccount = (Account) sobj;
        }
        sharingAccount(trgCtx);

    }

    public static  void sharingAccount(ClsWrappers.TriggerContext trgCtx) {
    	List<AccountShare> list_share = new List<AccountShare>();


    	Map<Id, Id> mapAssign = new Map<Id, Id>();
    	Map<String, Id> mapGroup  = new Map<String, Id>();
    	Map<String, Id> mapRecordType  = new Map<String, Id>();
    	List<Assign__c> listAssigns = Assign__c.getAll().values();
    	System.debug('mapAssign---------->' + listAssigns);

    	for (Group g : [SELECT Id, DeveloperName FROM Group]) {
    		mapGroup.put(g.DeveloperName, g.Id);
    	}
    	for (RecordType recordType : [SELECT Id,SobjectType, DeveloperName FROM RecordType WHERE SobjectType  = 'Account']) {
    		mapRecordType.put(recordType.DeveloperName, recordType.Id);
    	}


    	for (Assign__c assign : listAssigns) {
    		mapAssign.put(mapRecordType.get(assign.Record_Type__c), mapGroup.get(assign.Group__c));
    	}

    	System.debug('mapAssign111111---------->' + mapAssign);
    	System.debug('mapGroup---------->' + mapGroup);
    	System.debug('mapRecordType---------->' + mapRecordType);


    	if (trgCtx.isInsert) {
    		for (Account newaccount : (List<Account>)trgCtx.newList) {
    			System.debug('newaccount-------->' + newaccount);
    			String newaccountId = mapAssign.get(newaccount.RecordTypeId);
    			System.debug('newaccountId------>' + newaccountId);
    			AccountShare share = new AccountShare();
    			share.OpportunityAccessLevel = 'Edit';
    			share.UserOrGroupId = newaccountId;//需要共享给的用户 or 小组
	            share.AccountId = newaccount.id;//记录id
	            share.AccountAccessLevel = 'Edit'; //edit:读写/read：只读 
	            list_share.add(share);
    		}
    	}
    	System.debug('list_share------->' + list_share);

    	if (list_share.size() > 0) {
    		insert list_share;
    	}
    }

}