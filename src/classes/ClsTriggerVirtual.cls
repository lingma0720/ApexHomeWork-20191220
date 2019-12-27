public virtual class ClsTriggerVirtual implements IntTrigger {
    
    /** the map which catchs RecordType for the whole trigger chain to use */
    public static Map<String, Map<String, Id>> map_objName_rtDevName_rtId;
    
    /*
    protected IntHelper helper;
    
    public void setHelper(IntHelper helper) {
        this.helper = helper;
    }
    
    public IntHelper getHelper() {
        return this.helper == null ? ClsBeanFactory.getInstance().getHelper() : this.helper;
    }
    */
    
    /**
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public virtual void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
        
    }
    
    /**
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public virtual void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        
    }
    
    /**
     * This method is called for business logic execution of BEFORE trigger.
     *
     * The default implementation of this method would deal with the records in smaller granularity.
     * It can be overriden directly by any handlers if the business logic is relately complex.
     * Otherwise, handlers could override any precise method, like beforeInsert, beforeUpdate
     * and beforeDelete for ease. 
     */
    public virtual void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        // Iterate through the records to be deleted passing them to the handler.
        if (trgCtx.isDelete) {
            for (SObject so : trgCtx.oldList) {
                this.beforeDelete(so);
            }
        }
        
        // Iterate through the records to be inserted passing them to the handler.
        else if (trgCtx.isInsert) {
            for (SObject so : trgCtx.newList) {
                this.beforeInsert(so);
            }
        }
        
        // Iterate through the records to be updated passing them to the handler.
        else if (trgCtx.isUpdate) {
            for (SObject so : trgCtx.oldList) {
                this.beforeUpdate(so, trgCtx.newMap.get(so.Id));
            }
        }
        
    }
    
    /**
     * This method is called for business logic execution of BEFORE trigger.
     *
     * The default implementation of this method would deal with the records in smaller granularity.
     * It can be overriden directly by any handlers if the business logic is relately complex.
     * Otherwise, handlers could override any precise method, like afterInsert, afterUpdate
     * and afterDelete for ease. 
     */
    public virtual void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        // Iterate through the records deleted passing them to the handler.
        if (trgCtx.isDelete) {
            for (SObject so : trgCtx.oldList) {
                this.afterDelete(so);
            }
        }
        
        // Iterate through the records inserted passing them to the handler.
        else if (trgCtx.isInsert) {
            for (SObject so : trgCtx.newList) {
                this.afterInsert(so);
            }
        }
        
        // Iterate through the records updated passing them to the handler.
        else if (trgCtx.isUpdate) {
            for (SObject so : trgCtx.oldList) {
                this.afterUpdate(so, trgCtx.newMap.get(so.Id));
            }
        }
        
    }
    
    /**
     * This method is called iteratively for each record to be inserted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @param   so   an instance of SObject in trigger.new context 
     */
    public virtual void beforeInsert(SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record to be updated during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @param   oldSo   an instance of SObject in trigger.old context 
     * @param   newSo   an instance of SObject in trigger.new context 
     */
    public virtual void beforeUpdate(SObject oldSo, SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @param   so   an instance of SObject in trigger.old context 
     */
    public virtual void beforeDelete(SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record inserted during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     *
     * @param   so   an instance of SObject in trigger.new context 
     */
    public virtual void afterInsert(SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record updated during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     *
     * @param   oldSo   an instance of SObject in trigger.old context 
     * @param   newSo   an instance of SObject in trigger.new context 
     */
    public virtual void afterUpdate(SObject oldSo, SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record deleted during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     *
     * @param   so   an instance of SObject in trigger.old context 
     */
    public virtual void afterDelete(SObject so) {
        
    }
    
    /**
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public virtual void andFinally(ClsWrappers.TriggerContext trgCtx) {
        
    }
}