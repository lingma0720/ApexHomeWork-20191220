/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * Base class aiding in the implemetnation of a Domain Model around SObject collections
 *
 * Domain (software engineering). “a set of common requirements, terminology, and functionality
 * for any software program constructed to solve a problem in that field”,
 * http://en.wikipedia.org/wiki/Domain_(software_engineering)
 *
 * Domain Model, “An object model of the domain that incorporates both behavior and data.”,
 * “At its worst business logic can be very complex. Rules and logic describe many different "
 * "cases and slants of behavior, and it's this complexity that objects were designed to work with...”
 * Martin Fowler, EAA Patterns
 * http://martinfowler.com/eaaCatalog/domainModel.html
 *
 **/
public virtual class Cls_SObjectDomain implements Int_SObjectDomain{
    /**
     * Provides access to the data represented by this domain class
     **/
    public List<SObject> Records { get; private set;}

    /**
     * Derived from the records provided during construction, provides the native describe for the standard or custom object
     **/
    public Schema.DescribeSObjectResult SObjectDescribe {get; private set;}

    /**
     * Exposes the configuration for this domain class instance
     **/
    public Configuration Configuration {get; private set;}

    /**
     * Useful during unit testign to assert at a more granular and robust level for errors raised during the various trigger events
     **/
    public static ClsFactory_SObjectError Errors {get; private set;}

    /**
     * Retains instances of domain classes implementing trigger stateful
     **/
    private static Map<Type, List<Cls_SObjectDomain>> TriggerStateByClass;

    /**
     * Retains the trigger tracking configuraiton used for each domain
     **/
    private static Map<Type, TriggerEvent> TriggerEventByClass;

    static{
        Errors = ClsFactory_SObjectError.Instance;

        TriggerStateByClass = new Map<Type, List<Cls_SObjectDomain>>();

        TriggerEventByClass = new Map<Type, TriggerEvent>();
    }

    /**
     * Constructs the domain class with the data on which to apply the behaviour implemented within
     *
     * @param sObjectList A concreate list (e.g. List<Account> vs List<SObject>) of records

     **/
    public Cls_SObjectDomain(List<SObject> sObjectList){
        this(sObjectList, sObjectList.getSObjectType());
    }

    /**
     * Constructs the domain class with the data and type on which to apply the behaviour implemented within
     *
     * @param sObjectList A list (e.g. List<Opportunity>, List<Account>, etc.) of records
     * @param sObjectType The Schema.SObjectType of the records contained in the list
     *
     * @remark Will support List<SObject> but all records in the list will be assumed to be of
     *         the type specified in sObjectType
     **/
    public Cls_SObjectDomain(List<SObject> sObjectList, SObjectType sObjectType){
        // Ensure the domain class has its own copy of the data
        Records = sObjectList.clone();
        // Capture SObjectType describe for this domain class
        SObjectDescribe = sObjectType.getDescribe();
        // Configure the Domain object instance
        Configuration = new Configuration();
    }

    /**
     * Override this to apply defaults to the records, this is called by the handleBeforeInsert method
     **/
    public virtual void onApplyDefaults() { }

    /**
     * Override this to apply general validation to be performed during insert or update, called by the handleAfterInsert and handleAfterUpdate methods
     **/
    public virtual void onValidate() { }

    /**
     * Override this to apply validation to be performed during insert, called by the handleAfterUpdate method
     **/
    public virtual void onValidate(Map<Id,SObject> existingRecords)	{ }

    /**
     * Override this to perform processing during the before insert phase, this is called by the handleBeforeInsert method
     **/
    public virtual void onBeforeInsert() { }

    /**
     * Override this to perform processing during the before update phase, this is called by the handleBeforeUpdate method
     **/
    public virtual void onBeforeUpdate(Map<Id,SObject> existingRecords) { }

    /**
     * Override this to perform processing during the before delete phase, this is called by the handleBeforeDelete method
     **/
    public virtual void onBeforeDelete() { }

    /**
     * Override this to perform processing during the after insert phase, this is called by the handleAfterInsert method
     **/
    public virtual void onAfterInsert() { }
    /**
     * Override this to perform processing during the after update phase, this is called by the handleAfterUpdate method
     **/
    public virtual void onAfterUpdate(Map<Id,SObject> existingRecords) { }

    /**
     * Override this to perform processing during the after delete phase, this is called by the handleAfterDelete method
     **/
    public virtual void onAfterDelete() { }

    /**
     * Override this to perform processing during the after undelete phase, this is called by the handleAfterDelete method
     **/
    public virtual void onAfterUndelete() { }

    /**
     * Base handler for the Apex Trigger event Before Insert, calls the onApplyDefaults method, followed by onBeforeInsert
     **/
    public virtual void handleBeforeInsert(){
        onApplyDefaults();
        onBeforeInsert();
    }

    /**
     * Base handler for the Apex Trigger event Before Update, calls the onBeforeUpdate method
     **/
    public virtual void handleBeforeUpdate(Map<Id,SObject> existingRecords){
        onBeforeUpdate(existingRecords);
    }

    /**
     * Base handler for the Apex Trigger event Before Delete, calls the onBeforeDelete method
     **/
    public virtual void handleBeforeDelete(){
        onBeforeDelete();
    }

    /**
     * Base handler for the Apex Trigger event After Insert, checks object security and calls the onValidate and onAfterInsert methods
     *
     * @throws DomainException if the current user context is not able to create records
     **/
    public virtual void handleAfterInsert(){
        if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isCreateable())
            throw new DomainException('Permission to create an ' + SObjectDescribe.getName() + ' denied.');

        onValidate();
        onAfterInsert();
    }

    /**
     * Base handler for the Apex Trigger event After Update, checks object security and calls the onValidate, onValidate(Map<Id,SObject>) and onAfterUpdate methods
     *
     * @throws DomainException if the current user context is not able to update records
     **/
    public virtual void handleAfterUpdate(Map<Id,SObject> existingRecords){
        if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isUpdateable())
            throw new DomainException('Permission to udpate an ' + SObjectDescribe.getName() + ' denied.');

        if(Configuration.OldOnUpdateValidateBehaviour)
            onValidate();
        onValidate(existingRecords);
        onAfterUpdate(existingRecords);
    }

    /**
     * Base handler for the Apex Trigger event After Delete, checks object security and calls the onAfterDelete method
     *
     * @throws DomainException if the current user context is not able to delete records
     **/
    public virtual void handleAfterDelete(){
        if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isDeletable())
            throw new DomainException('Permission to delete an ' + SObjectDescribe.getName() + ' denied.');

        onAfterDelete();
    }

    /**
     * Base handler for the Apex Trigger event After Undelete, checks object security and calls the onAfterUndelete method
     *
     * @throws DomainException if the current user context is not able to delete records
     **/
    public virtual void handleAfterUndelete(){
        if(Configuration.EnforcingTriggerCRUDSecurity && !SObjectDescribe.isCreateable())
            throw new DomainException('Permission to create an ' + SObjectDescribe.getName() + ' denied.');

        onAfterUndelete();
    }

    /**
     * Returns the SObjectType this Domain class represents
     **/
    public SObjectType getSObjectType(){
        return SObjectDescribe.getSObjectType();
    }

    /**
     * Returns the SObjectType this Domain class represents
     **/
    public SObjectType sObjectType(){
        return getSObjectType();
    }

    /**
     * Alternative to the Records property, provided to support mocking of Domain classes
     **/
    public List<SObject> getRecords(){
        return Records;
    }

    /**
     * Ensures logging of errors in the Domain context for later assertions in tests
     **/
    public String error(String message, SObject record){
        return Errors.error(this.sObjectType(), message, record);
    }

    /**
     * Ensures logging of errors in the Domain context for later assertions in tests
     **/
    public String error(String message, SObject record, SObjectField field){
        return Errors.error(this.sObjectType(), message, record, field);
    }

    /**
     * Interface used to aid the triggerHandler in constructing instances of Domain classes
     **/
    public interface IConstructable{
        Cls_SObjectDomain construct(List<SObject> sObjectList);
    }

    /**
     * Interface used to aid the triggerHandler in constructing instances of Domain classes
     **/
    public interface IConstructable2 extends IConstructable{
        Cls_SObjectDomain construct(List<SObject> sObjectList, SObjectType sObjectType);
    }

    /**
     * For Domain classes implementing the ITriggerStateful interface returns the instance
     *   of the domain class being shared between trigger invocations, returns null if
     *   the Domain class trigger has not yet fired or the given domain class does not implement
     *   the ITriggerStateful interface. Note this method is sensitive to recursion, meaning
     *   it will return the applicable domain instance for the level of recursion
     **/
    public static Cls_SObjectDomain getTriggerInstance(Type domainClass){
        List<Cls_SObjectDomain> domains = TriggerStateByClass.get(domainClass);
        if(domains==null || domains.size()==0)
            return null;
        return domains[domains.size()-1];
    }

    /**
     * Method constructs the given Domain class with the current Trigger context
     * before calling the applicable override methods such as beforeInsert, beforeUpdate etc.
     **/
    public static void triggerHandler(Type domainClass){
        // Process the runtime Apex Trigger context
        triggerHandler(domainClass,
                Trigger.isBefore,
                Trigger.isAfter,
                Trigger.isInsert,
                Trigger.isUpdate,
                Trigger.isDelete,
                Trigger.isUnDelete,
                Trigger.new,
                Trigger.oldMap
                );
    }

    /**
     * Calls the applicable override methods such as beforeInsert, beforeUpdate etc. based on a Trigger context
     **/
    private static void triggerHandler(Type domainClass, Boolean isBefore, Boolean isAfter,
            Boolean isInsert, Boolean isUpdate, Boolean isDelete,
            Boolean isUndelete, List<SObject> newRecords, Map<Id, SObject> oldRecordsMap){
        // After phase of trigger will reuse prior instance of domain class if ITriggerStateful implemented
        Cls_SObjectDomain domainObject = isBefore ? null : popTriggerInstance(domainClass, isDelete ? oldRecordsMap.values() : newRecords);
        if(domainObject==null){
            // Construct the domain class constructor class
            String domainClassName = domainClass.getName();
            Type constructableClass = domainClassName.endsWith('Constructor') ? Type.forName(domainClassName) : Type.forName(domainClassName+'.Constructor');
            IConstructable domainConstructor = (IConstructable) constructableClass.newInstance();

            // Construct the domain class with the approprite record set
            if(isInsert) domainObject = domainConstructor.construct(newRecords);
            else if(isUpdate) domainObject = domainConstructor.construct(newRecords);
            else if(isDelete) domainObject = domainConstructor.construct(oldRecordsMap.values());
            else if(isUndelete) domainObject = domainConstructor.construct(newRecords);

            // Should this instance be reused on the next trigger invocation?
            if(domainObject.Configuration.TriggerStateEnabled)
                // Push this instance onto the stack to be popped during the after phase
                pushTriggerInstance(domainClass, domainObject);
        }

        // has this event been disabled?
        if(!getTriggerEvent(domainClass).isEnabled(isBefore, isAfter, isInsert, isUpdate, isDelete, isUndelete)){
            return;
        }

        // Invoke the applicable handler
        if(isBefore){
            if(isInsert) domainObject.handleBeforeInsert();
            else if(isUpdate) domainObject.handleBeforeUpdate(oldRecordsMap);
            else if(isDelete) domainObject.handleBeforeDelete();
        }
        else{
            if(isInsert) domainObject.handleAfterInsert();
            else if(isUpdate) domainObject.handleAfterUpdate(oldRecordsMap);
            else if(isDelete) domainObject.handleAfterDelete();
            else if(isUndelete) domainObject.handleAfterUndelete();
        }
    }

    /**
     * Pushes to the stack of domain classes per type a domain object instance
     **/
    private static void pushTriggerInstance(Type domainClass, Cls_SObjectDomain domain){
        List<Cls_SObjectDomain> domains = TriggerStateByClass.get(domainClass);
        if(domains==null)
            TriggerStateByClass.put(domainClass, domains = new List<Cls_SObjectDomain>());

        domains.add(domain);
    }

    /**
     * Pops from the stack of domain classes per type a domain object instance and updates the record set
     **/
    private static Cls_SObjectDomain popTriggerInstance(Type domainClass, List<SObject> records){
        List<Cls_SObjectDomain> domains = TriggerStateByClass.get(domainClass);
        if(domains==null || domains.size()==0)
            return null;

        Cls_SObjectDomain domain = domains.remove(domains.size()-1);
        domain.Records = records;
        return domain;
    }

    public static TriggerEvent getTriggerEvent(Type domainClass){
        if(!TriggerEventByClass.containsKey(domainClass)){
            TriggerEventByClass.put(domainClass, new TriggerEvent());
        }

        return TriggerEventByClass.get(domainClass);
    }

    public class TriggerEvent{
        public boolean BeforeInsertEnabled {get; private set;}
        public boolean BeforeUpdateEnabled {get; private set;}
        public boolean BeforeDeleteEnabled {get; private set;}

        public boolean AfterInsertEnabled {get; private set;}
        public boolean AfterUpdateEnabled {get; private set;}
        public boolean AfterDeleteEnabled {get; private set;}
        public boolean AfterUndeleteEnabled {get; private set;}

        public TriggerEvent(){
            this.enableAll();
        }

        // befores
        public TriggerEvent enableBeforeInsert() 	{BeforeInsertEnabled = true; return this;}
        public TriggerEvent enableBeforeUpdate() 	{BeforeUpdateEnabled = true; return this;}
        public TriggerEvent enableBeforeDelete() 	{BeforeDeleteEnabled = true; return this;}

        public TriggerEvent disableBeforeInsert() 	{BeforeInsertEnabled = false; return this;}
        public TriggerEvent disableBeforeUpdate() 	{BeforeUpdateEnabled = false; return this;}
        public TriggerEvent disableBeforeDelete() 	{BeforeDeleteEnabled = false; return this;}

        // afters
        public TriggerEvent enableAfterInsert() 	{AfterInsertEnabled 	= true; return this;}
        public TriggerEvent enableAfterUpdate() 	{AfterUpdateEnabled 	= true; return this;}
        public TriggerEvent enableAfterDelete() 	{AfterDeleteEnabled 	= true; return this;}
        public TriggerEvent enableAfterUndelete() 	{AfterUndeleteEnabled 	= true; return this;}


        public TriggerEvent disableAfterInsert()	{AfterInsertEnabled 	= false; return this;}
        public TriggerEvent disableAfterUpdate()	{AfterUpdateEnabled 	= false; return this;}
        public TriggerEvent disableAfterDelete()	{AfterDeleteEnabled 	= false; return this;}
        public TriggerEvent disableAfterUndelete()	{AfterUndeleteEnabled 	= false; return this;}

        public TriggerEvent enableAll(){
            return this.enableAllBefore().enableAllAfter();
        }

        public TriggerEvent disableAll(){
            return this.disableAllBefore().disableAllAfter();
        }

        public TriggerEvent enableAllBefore(){
            return this.enableBeforeInsert().enableBeforeUpdate().enableBeforeDelete();
        }

        public TriggerEvent disableAllBefore(){
            return this.disableBeforeInsert().disableBeforeUpdate().disableBeforeDelete();
        }

        public TriggerEvent enableAllAfter(){
            return this.enableAfterInsert().enableAfterUpdate().enableAfterDelete().enableAfterUndelete();
        }

        public TriggerEvent disableAllAfter(){
            return this.disableAfterInsert().disableAfterUpdate().disableAfterDelete().disableAfterUndelete();
        }

        public boolean isEnabled(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete){
            if(isBefore){
                if(isInsert) return BeforeInsertEnabled;
                else if(isUpdate) return BeforeUpdateEnabled;
                else if(isDelete) return BeforeDeleteEnabled;
            }
            else if(isAfter){
                if(isInsert) 		return AfterInsertEnabled;
                else if(isUpdate) 	return AfterUpdateEnabled;
                else if(isDelete) 	return AfterDeleteEnabled;
                else if(isUndelete) return AfterUndeleteEnabled;
            }

            return true; // should nnt ever get here!
        }
    }

    /**
     * Fluent style Configuration system for Domain class creation
     **/
    public class Configuration
    {
        /**
         * Backwards compatability mode for handleAfterUpdate routing to onValidate()
         **/
        public Boolean OldOnUpdateValidateBehaviour {get; private set;}
        /**
         * True if the base class is checking the users CRUD requirements before invoking trigger methods
         **/
        public Boolean EnforcingTriggerCRUDSecurity {get; private set;}

        /**
         * Enables reuse of the same Domain instance between before and after trigger phases (subject to recursive scenarios)
         **/
        public Boolean TriggerStateEnabled {get; private set;}

        /**
         * Default configuration
         **/
        public Configuration(){
            EnforcingTriggerCRUDSecurity = true; // Default is true for backwards compatability
            TriggerStateEnabled = false;
            OldOnUpdateValidateBehaviour = false; // Breaking change, but felt to better practice
        }

        /**
         * See associated property
         **/
        public Configuration enableTriggerState(){
            TriggerStateEnabled = true;
            return this;
        }

        /**
         * See associated property
         **/
        public Configuration disableTriggerState(){
            TriggerStateEnabled = false;
            return this;
        }

        /**
         * See associated property
         **/
        public Configuration enforceTriggerCRUDSecurity(){
            EnforcingTriggerCRUDSecurity = true;
            return this;
        }

        /**
         * See associated property
         **/
        public Configuration disableTriggerCRUDSecurity(){
            EnforcingTriggerCRUDSecurity = false;
            return this;
        }

        /**
         * See associated property
         **/
        public Configuration enableOldOnUpdateValidateBehaviour(){
            OldOnUpdateValidateBehaviour = true;
            return this;
        }

        /**
         * See associated property
         **/
        public Configuration disableOldOnUpdateValidateBehaviour(){
            OldOnUpdateValidateBehaviour = false;
            return this;
        }
    }

    /**
     * General exception class for the domain layer
     **/
    public class DomainException extends Exception{}

}