@isTest
private class ClsSObjectDescribe_Test {

    /**
     * Verify that the different ways of getting your hands on an ClsSObjectDescribe instance all handle null inputs
     * (and blank/empty strings, why not?) by returning null - since there's no possible way to resolve it.
    **/
    @isTest
    static void getDescribe_badInput(){
        ClsSObjectDescribe.testFunction();
    }

}