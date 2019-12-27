public class ClsTriggerFactory {

    /**
     *  Global test run skipper as privat static member
     */
    public static Boolean isSkipTrigger = false;

    /**
     *  Test run skippers for all trigger handlers as privat static member in form of map
     */
    public static Map<String, Boolean> map_handler_isSkip = new Map<String, Boolean>();
    
    /**
     *  Public static method to create and execute a trigger handler
     *  Throws a ClsTriggerException if no handler has been registered.
     *
     * @param   soType      the Sobject Type, on which the current trigger is running
     */
    public static void createHandler(Schema.sObjectType soType) {

        // Get a handler appropriate to the object being processed
        IntTrigger handler = getHandler(soType);
        
        // Make sure we have a handler registered, 
        //new handlers must be registered in the getHandler method.
        if (handler == null) {
            
            throw new ClsTriggerException('No Trigger Handler registered for Object Type: ' 
                                            + soType);
        }
        
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
     *  Private static method to control the execution of the handler
     * - trigger test run skipper examination
     * - runs in before trigger context
     * - runs in after trigger context
     *
     * @param   handler     trigger handler interface
     */
    private static void execute(IntTrigger handler) {

        Boolean skip = false;

        // The skip flag in the map has a higher priority than global flag
        if (map_handler_isSkip.containsKey(String.valueOf(handler).split(':')[0])) {
            skip = map_handler_isSkip.get(String.valueOf(handler).split(':')[0]);
        } else if (ClsTriggerFactory.isSkipTrigger) {
            skip = ClsTriggerFactory.isSkipTrigger;
        }
        
        if (skip) {
            // The handler should be skipped
            return;
        }

        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);

        // Before Trigger
        if (Trigger.isBefore) {

            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore(trgCtx);
            
            // Execute business logic in before trigger context
            handler.beforeTrigger(trgCtx);
            
        } else {

            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter(trgCtx);
            
            // Execute business logic in after trigger context
            handler.afterTrigger(trgCtx);
            
        }
         
        // Perform any post processing
        handler.andFinally(trgCtx);
    }
    
    /**
     *  Public static method to set global test run skipper
     *
     * @param   skip        true or false
     */
    public static void setSkipHandlers(Boolean skip) {
        isSkipTrigger = skip;
    }
    
    /**
     *  Public static method to set test run skipper a specific trigger handler
     *
     * @param   handlerName     the hander name as string
     * @param   skip            true or false
     */
    public static void setSkipHandler(String handlerName, Boolean skip) {
        map_handler_isSkip.put(handlerName, skip);
    }
    
    /**
     *  Private static method to get the appropriate handler for the object type.
     *  Modify this method to register any additional handlers.
     *
     * @param   soType      the Sobject Type, on which the current trigger is running
     * @return  IntTrigger  the trigger handler interface if exists, or null
     */
    private static IntTrigger getHandler(Schema.sObjectType soType) {
        
        if (soType == Case.sObjectType) {
            //return new ClsTrg_CaseHandler();
            return new ClsTriggerCreateTaskHandler();
        }

        if (soType == Account.sObjectType) {
            return new AccountSharing();
        }
        
        return null;
    }
    
}