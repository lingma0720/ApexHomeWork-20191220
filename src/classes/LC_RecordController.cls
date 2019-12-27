/**
 * Created by meixing on 2019-10-03.
 */

public with sharing class LC_RecordController {
    /**
     * This method used to retrieve the record via the specified SObjectType and record Id.
     *
      @param objectName     String     Specifies the SObjectType token to retrieve
      @param recordIds      Set         Specifies the record Ids to retrieve
      @param fieldNames     List     Specifies a list of field name to retrieve
      @param filter         String     Specifies a list of field name to retrieve
      @return List<SObject> A list of sobject records
      @author Zhuoxue Jin
      @created 2018-10-08
     **/
    @AuraEnabled
    public static String getRecords(String objectName, List<String> recordIds, List<String> fieldNames, String filter, String ordersJSON, Integer limitCount)
    {
        List<ClsQueryFactory.Ordering> orders = new List<ClsQueryFactory.Ordering>();
        if (ordersJSON != null && ordersJSON != '') {
            orders = (List<ClsQueryFactory.Ordering>)JSON.deserialize(ordersJSON,List<ClsQueryFactory.Ordering>.class);
        }

        return JSON.serialize(ClsRecordService.queryRecords(objectName,recordIds,fieldNames,filter,orders,limitCount));
    }
}