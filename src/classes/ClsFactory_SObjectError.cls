/**
* A factory class used to save the errors in a transaction.
*
@author  Jin Zhuoxue
@created 2018-08-30
@version 1.0
@since   43.0 (Force.com ApiVersion)
*
@changelog
* 2018-08-30   Zhuoxue Jin <zhuoxue.jin@capgemini.com>
* - Created
*/
public class ClsFactory_SObjectError {
    
    private List<Error> errorList = new List<Error>();
    
    public static ClsFactory_SObjectError Instance {
        get{
            if(Instance == null)
                Instance = new ClsFactory_SObjectError();
            return Instance;
        }
        private set;
    }
    
    private ClsFactory_SObjectError(){
        
    }
    
    public String error(String message, SObject record){
        return error(null, message, record);
    }
    
    public String error(SObjectType objectType, String message, SObject record){
        ObjectError objectError = new ObjectError();
        objectError.objectType = objectType != null ? objectType.getDescribe().getName() : null;
        objectError.message = message;
        objectError.record = record;
        errorList.add(objectError);
        return message;
    }
    
    public String error(String message, SObject record, SObjectField field){
        return error(null, message, record, field);
    }
    
    public String error(SObjectType objectType, String message, SObject record, SObjectField field){
        FieldError fieldError = new FieldError();
        fieldError.objectType = objectType != null ? objectType.getDescribe().getName() : null;
        fieldError.message = message;
        fieldError.record = record;
        fieldError.field = field != null ? field.getDescribe().getName() : null;
        errorList.add(fieldError);
        return message;
    }
    
    public List<Error> getAll(){
        return errorList.clone();
    }
    
    public void clearAll(){
        errorList.clear();
    }
    
    
    /**
* Ensures logging of errors in the Domain context for later assertions in tests
**/
    public virtual class FieldError extends ObjectError{
        public String field;
        
        public FieldError()
        {
            
        }
    }
    
    /**
* Ensures logging of errors in the Domain context for later assertions in tests
**/
    public virtual class ObjectError extends Error{
        public SObject record;
        
        public ObjectError()
        {
            
        }
    }
    
    /**
* Using string to represent the SObjectType because the Apex Type is unsupported in JSON: Schema.SObjectField and Schema.SObjectType
**/
    public abstract class Error{
        public String message;
        public String objectType;
    }
}