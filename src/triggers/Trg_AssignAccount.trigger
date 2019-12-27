trigger Trg_AssignAccount on Account(after insert, after update) {
    ClsTriggerFactory.createHandler(Account.sObjectType);
}