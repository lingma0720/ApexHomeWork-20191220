/**
 * Created by meixing on 2019-05-17.
 */

public with sharing class ClsRecordService {
    /**
     * the method used to query records
     *
     * @param objectName
     * @param recordIds
     * @param fieldNames
     * @param filter
     * @param orders
     * @param limitCount
     *
     * @return
     */

    public static List<Sobject> queryRecords(String objectName, List<String> recordIds,
            List<String> fieldNames, String filter, List<ClsQueryFactory.Ordering> orders, Integer limitCount){
        ClsQueryFactory qf = new ClsQueryFactory(ClsSObjectDescribe.getDescribe(objectName).getSObjectType());
        qf.selectFields(fieldNames);
        String condition = '';
        if(recordIds!= null && !recordIds.isEmpty()){
            condition = 'Id In :recordIds';
        }

        if(!String.isBlank(filter)){
            condition += (String.isBlank(condition) ? filter : ' And '+filter);
        }
        if(!String.isBlank(condition)){
            qf.setCondition(condition);
        }

        if(orders != null && !orders.isEmpty()){
            for(ClsQueryFactory.Ordering o : orders){
                qf.addOrdering(o);
            }
        }

        if(limitCount != null){
            qf.setLimit(limitCount);
        }
        system.debug(qf.toSOQL());

        return Database.query(qf.toSOQL());
    }

    /**
     * the method to notificate user for one record
     *
     * @param recordId
     * @param message notificate info
     * @param users target user
     */
    public static void notificateUser(String recordId, String message, Set<String> users, String relatedTicket){

        List<Task> notifications = new List<Task>();

        for(String userId : users){
            notifications.add(resolveReminderTask(recordId,message,userId, relatedTicket));
        }

        insert notifications;

    }

    public static Task resolveReminderTask(String recordId, String message, String userId, String relatedTicket){
        Task t = new Task();
        t.ReminderDateTime = DateTime.now();
        t.Priority = 'High';
        t.ActivityDate = Date.today();
        t.IsReminderSet = true;
        t.Subject = message;
        t.OwnerId = userId;
        t.WhatId = recordId;
        t.Status = 'Open';

        return t;
    }

}