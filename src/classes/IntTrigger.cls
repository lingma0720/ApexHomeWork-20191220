/**
 * Interface containing methods. Trigger Handlers must implement to enforce best practice
 * and bulkification of triggers.
 *
 @author  Qiang Cao
 @created 2015-08-07    
 @version 1.0
 @since   31.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-08-07  Qiang Cao <qiang.cao@oinio.com>
 * - Created
 */
 
public interface IntTrigger {

    /**
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     *
     */
    void bulkBefore(ClsWrappers.TriggerContext trgCtx);

    /**
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    void bulkAfter(ClsWrappers.TriggerContext trgCtx);
    
    /**
     * This method is called for business logic execution of BEFORE trigger.
     */
    void beforeTrigger(ClsWrappers.TriggerContext trgCtx);

    /**
     * This method is called for business logic execution of AFTER trigger.
     */
    void afterTrigger(ClsWrappers.TriggerContext trgCtx);
    
    /**
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     */
    void andFinally(ClsWrappers.TriggerContext trgCtx);
    
}