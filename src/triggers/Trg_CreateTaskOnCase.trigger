trigger Trg_CreateTaskOnCase on Case(after insert, after update) {
    ClsTriggerFactory.createHandler(Case.sObjectType);
}