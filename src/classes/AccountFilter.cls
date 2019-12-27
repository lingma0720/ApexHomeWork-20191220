/*public with sharing class AccountFilter {
 
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of contacts to display
  public List<Account> accounts {get;set;}
 
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
 
  // init the controller and display some sample data when the page loads
  public AccountFilter() {

    soql = 'select Name, AccountNumber, Provice__c, City__c  from Account where name != null';
    runQuery();
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 
    try {
      contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String accountName = Apexpages.currentPage().getParameters().get('Name');
    String accountNumber = Apexpages.currentPage().getParameters().get('AccountNumber');
    String accountProvice = Apexpages.currentPage().getParameters().get('provice');
    String accountCity = Apexpages.currentPage().getParameters().get('city');
     
    soql = 'select Name, AccountNumber, Provice__c, City__c from Account where name != null';
    if (!accountNumber.equals(''))
      soql += ' and accountNumber LIKE \''+String.escapeSingleQuotes(accountNumber)+'%\'';
    if (!accountProvice.equals(''))
      soql += ' and accountProvice LIKE \''+String.escapeSingleQuotes(accountProvice)+'%\'';
    if (!accountCity.equals(''))
      soql += ' and accountCity LIKE \''+String.escapeSingleQuotes(accountCity)+'%\'';  
     
    // run the query again
    runQuery();
 
    return null;
  }

   

}*/

public with sharing class AccountFilter {
    public Account account{get;set;}
    public list<Account> listOfAccounts{get;set;}
    public String accountName = '';
    public String accountNumber = '';
    public String accountProvice = '';
    public String accountCity = '';
    public AccountFilter() {
       
        account = new Account();
    }

     public void  runSearch(){
        accountName = account.Name; 
        System.debug('accountName------------->'+ accountName);
        accountNumber = account.AccountNumber;
        System.debug('accountNumber------------->'+ accountNumber);
        accountProvice = account.Province__c;
        System.debug('accountProvice------------->'+ accountProvice);
        accountCity = account.City__c;
        System.debug('accountCity------------->'+ accountCity);
        /*if (accountName == '' || accountName == null) {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter the Account name'));
        }*/

          String filter = 'SELECT Id, Name, AccountNumber, Province__c, City__c FROM Account WHERE ';
         
          if (accountName != '' || accountName != null){
             System.debug('111111------------>');
            filter = filter + 'Name like \'%' +accountName +'%\'';
          } 

          if ( accountNumber != null){
             System.debug('22222------------->');
            filter =filter + ' and AccountNumber like\'%' +accountNumber +'%\'';
          } 
          if  (accountProvice != null){
             System.debug('33333----------->');
            filter = filter   +' and Province__c =\'' +accountProvice +'\'';
          } 
          if  (accountCity != null){
             System.debug('4444444--------->');
            filter =  filter +' and City__c =\'' +accountCity +'\'' ;
          } 

          System.debug('filter------------->' + filter);
          listOfAccounts = Database.query(filter);

          System.debug('listOfAccounts---------222222---->'+ listOfAccounts);
     }

}