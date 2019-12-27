trigger Trg_CaseStatus on Case(after insert, after update) {
    //Cls_SObjectDomain.triggerHandler(ClsTrg_CaseHandler.class);
     ClsTriggerFactory.createHandler(Case.sObjectType);
}