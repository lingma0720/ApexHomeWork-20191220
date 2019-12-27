@isTest
private class ClsBitset_Test {
    static testMethod void testMethod1() {
        //User admin = PMKT_ClsTestUtils.createAdmin('applicant');

        //System.runAs(admin){
        Integer[] nList = new Integer[]{65,66,67,68,69,70,71,72,73,74,
                75,76,77,78,79,80,81,82,83,84,
                85,86,87,88,89,90};
        String pValidFor = 'TESTpValidFor';
        ClsBitset bitSet = new ClsBitset();
        bitSet.testBits(pValidFor, nList);
	    //}
    }
}