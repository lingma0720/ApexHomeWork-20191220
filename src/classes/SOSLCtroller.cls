public with sharing class SOSLCtroller {

	  public class RetrieveWrapper {
        //keyword:used to retrieve this
        public String retrieveKeyword{get;set;}
        //search group： values :(ALL FIELDS/EMAIL FIELDS/NAME FIELDS/PHONE FIELDS/SIDEBAR FIELDS)
        public String searchGroup{get;set;}
        //obj api name -> field    eg: account->[Name,Site]
        public Map<String,List<String>> objName2FieldsMap{get;set;}
        //obj api name -> condition eg : account -> where name like 'test%' order by name asc limit 10 offset 1
        public Map<String,String> objName2QueryConditionMap{get;set;}
    }

    public class SearchResultWrapper {
        //sobject api name  eg:Account
        public String objName{get;set;}
        //sObject Field Name => Value 
        public Map<String,Object> objFieldName2Value{get;set;}
    }

    public static List<SearchResultWrapper> search(RetrieveWrapper wrapper) {
        String retrieveSQL = buildRetrieveSQL(wrapper);
        System.debug('retrieveSQL--------23--->' + retrieveSQL);
        List<SearchResultWrapper> searchResultWrappers = new List<SearchResultWrapper>();
        if(retrieveSQL == null || (!retrieveSQL.contains('FIND'))) {
            return null;
        }
        System.debug(LoggingLevel.INFO, '*** retrieveSQL: ' + retrieveSQL);
        List<List<sObject>> searchResults = search.query(retrieveSQL);
        if(searchResults.size() > 0) {
            for(List<sObject> objs : searchResults) {
                String objName;
                if(objs.size() > 0) {
                    String objId = objs.get(0).Id;
                    objName = getAPINameByObjId(objId);
                }
                List<String> retrieveFields;
                if(objName != null) {

                    if(wrapper.objName2FieldsMap != null && wrapper.objName2FieldsMap.get(objName) != null) {
                        retrieveFields = wrapper.objName2FieldsMap.get(objName);
                    } else {
                        retrieveFields = getAvailableFields(objName);
                    }
                }

                for(sObject obj : objs) {
                    SearchResultWrapper  resultWrapper = new SearchResultWrapper();
                    resultWrapper.objName = objName;
                    Map<String,Object> fieldValueMap = new Map<String,Object>();
                    for(String field : retrieveFields){
                        if(obj.get(field) != null) {
                            fieldValueMap.put(field, obj.get(field));
                        }
                    }
                    resultWrapper.objFieldName2Value = fieldValueMap;
                    searchResultWrappers.add(resultWrapper);
                }
            }
        }
        return searchResultWrappers;
    }

    private static String buildRetrieveSQL(RetrieveWrapper wrapper) {
        String fetchSQL;
        if(wrapper.retrieveKeyword != null && wrapper.retrieveKeyword.trim() != '') {
            String keyword = '\'' + wrapper.retrieveKeyword + '\'';
            fetchSQL = 'FIND ' + keyword;

            if(wrapper.searchGroup != null) {
                fetchSQL += ' IN ' + wrapper.searchGroup;
            } else {
                fetchSQL += ' IN ALL FIELDS';
            }

            if(wrapper.objName2FieldsMap != null) {
                List<String> objToFieldsList = new List<String>();
                for(String key : wrapper.objName2FieldsMap.keySet()) {
                    String objName = key;
                    String fieldStr;
                    if(wrapper.objName2FieldsMap != null && wrapper.objName2FieldsMap.get(objName) != null) {
                        fieldStr = String.join(wrapper.objName2FieldsMap.get(objName),',');
                    } else {
                        fieldStr = String.join(getAvailableFields(objName), ',');
                    }
                    String filterStr;
                    if(wrapper.objName2QueryConditionMap != null) {
                        filterStr = wrapper.objName2QueryConditionMap.get(objName);
                    }

                    if(String.isNotEmpty(filterStr)){
                        fieldStr = '(' + fieldStr + ' WHERE ' + filterStr +')';
                    }
                    else{
                        if(fieldStr != null) {
                            fieldStr = '(' + fieldStr +')';
                        }
                    }
                    if(fieldStr != null) {
                        objName = key + fieldStr;
                    } else {
                        objName = key;
                    }
                    
                    objToFieldsList.add(objName);
                }

                if(objToFieldsList.size() > 0) {
                    fetchSQL += ' RETURNING ' + String.join(objToFieldsList, ',');
                }
            }
        }
        return fetchSQL;
    }

    private static String getAPINameByObjId(String objId) {
        String objPrefix = objId.left(3);
        return objId2APIName.get(objPrefix);
    }


    private static Map<String,String> objId2APIName {
        get {
            if(objId2APIName == null) {
                objId2APIName = new Map<String,String>();
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                for(String objectName : gd.keySet()) {
                    Schema.SObjectType objectType = gd.get(objectName);
                    String prefix = objectType.getDescribe().getKeyPrefix();
                    if(prefix != null) {
                        objId2APIName.put(prefix, objectName);
                    }
                }
            }
            return objId2APIName;
        }
        set;
    }

    private static List<String> getAvailableFields(String objName) {
        List<String> availableFields = new List<String>();
        List<Schema.DescribeSObjectResult> objDescribes = Schema.describeSObjects(new List<String>{objName});
        Schema.DescribeSObjectResult objDescribe;
        if(objDescribes != null && objDescribes.size() > 0) {
            objDescribe = objDescribes.get(0);
        } else {
            return null;
        }
        Map<String,SObjectField> sObjectFieldMaps = objDescribe.fields.getMap();
        for(String objField : sObjectFieldMaps.keySet()) {
            SObjectField field = sObjectFieldMaps.get(objField);
            DescribeFieldResult fieldResult = field.getDescribe();
            if(fieldResult.isAccessible()) {
                availableFields.add(fieldResult.getName());
            }
        }
        return availableFields;
    }
    
}