public class ContactSearchController {
    public list <Account> acc {get;set;}
    public String searchKey {get;set;}
    public ContactSearchController( ) {
    }

    public void search(){
        string searchquery='select Name,id from account where name like \'%'+searchKey+'%\' Limit 10';
        acc= Database.query(searchquery);
    }

    public void clear(){
        acc.clear();
    }
}
/*public with sharing class ContactSearchController 
{
    public Account acc {get;set;}   
    public ApexPages.StandardSetController con{get; set;} 
    public CustomPaginationController ()
    {
       acc = new Account();
       lstAccount = new List<Account>();
    }
    public List<Account> lstAccount 
    {  
        get  
        {  
            if(con != null)  
                return (List<Account>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }  
    public PageReference Search()
    {
        String query= '';
        String strFilter = '';
        if(acc.Name != null && (acc.Name ).trim() !='')
        {
           strFilter  = strFilter  +  ' where Name Like \''+acc.Name+'%\'' ;
        }
        if(acc.Phone != null && (acc.Phone).trim() !='' )
        {
           if(strFilter == '')
           { 
               strFilter  = strFilter  +  ' where Phone like \''+acc.Phone+'%\'' ;
           }
           else
           {
               strFilter  = strFilter  +  ' And Phone like \''+acc.Phone+'%\'' ;
           }
        }
        if(strFilter != '')
        {
            query = 'Select name ,id, phone from Account '+strFilter+ ' limit 1000';
            System.debug('Query ---->'+ query );
            con = new ApexPages.StandardSetController(Database.getQueryLocator(query)); 
            con.setPageSize(2);
        }
        else
        {
        }
       return null;
    }
    public Boolean hasNext  
    {  
        get  
        {  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    public Integer pageNumber  
    {  
        get  
        {  
            return con.getPageNumber();  
        }  
        set;  
    }  
    public void previous()  
    {  
        con.previous();  
    }  
    public void next()  
    {  
        con.next();  
    }  
   
}*/