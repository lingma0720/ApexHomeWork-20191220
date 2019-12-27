/**
 * Created by meixing on 2019-10-05.
 */

public with sharing class LC_DepartmentController {

    @AuraEnabled
    public static List<Department__c> getEmployeeDepartments(String employeeId) {
        List<Department__c> allRelatedDepartments = new List<Department__c>();
        Set<String> allRelatedDepartmentIds = new Set<String>();

        for (Employee__c employee : [SELECT Department__c, Department__r.Parent__c FROM Employee__c WHERE Id = :employeeId]) {
            allRelatedDepartmentIds.add(employee.Department__c);
            allRelatedDepartmentIds.add(employee.Department__r.Parent__c);
        }

        for (Department__c department : [SELECT Id, Name, Parent__c, PrimaryContact__c, PrimaryContact__r.Name, PrimaryContact__r.Phone__c
                                         FROM Department__c
                                         WHERE Id IN :allRelatedDepartmentIds]) {
            allRelatedDepartments.add(department);
        }

        return allRelatedDepartments;
    }



}