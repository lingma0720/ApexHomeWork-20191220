public with sharing class AccountCtroller {

//Test1111
    public list<Account> listOfAccounts{get;set;}

    public AccountCtroller() {
    	listOfAccounts = [SELECT Id, Name, AccountNumber, Province__c,City__c FROM Account];
    	System.debug('******listOfAccounts' + listOfAccounts);
    }

}