/**
 * Interface for SObject Domain Class.
 *
 @author  Jin Zhuoxue
 @created 2017-06-29
 @version 1.0
 @since   39.0 (Force.com ApiVersion)
 *
 @changelog
 * 2017-06-22  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 */
public interface Int_SObjectDomain {
    /**
     * Returns the token for this wrapped SObject
     **/
    SObjectType sObjectType();

    /**
     * Returns the records of the current context
     **/
    List<SObject> getRecords();
}