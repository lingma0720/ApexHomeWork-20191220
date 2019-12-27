<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateAccountCity</fullName>
        <field>Province__c</field>
        <literalValue>上海市</literalValue>
        <name>UpdateAccountCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateAccountCityTwo</fullName>
        <field>City__c</field>
        <literalValue>嘉定区</literalValue>
        <name>UpdateAccountCityTwo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateAccountField</fullName>
        <field>City__c</field>
        <literalValue>浦东区</literalValue>
        <name>UpdateAccountField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateAccountFieldTT</fullName>
        <field>AccountNumber</field>
        <formula>IF(Account__r.AccountNumber == &apos;3333&apos;, &apos;8888&apos;, &apos;9999&apos;)</formula>
        <name>UpdateAccountFieldTT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEmployeeField</fullName>
        <field>SelfDescription__c</field>
        <formula>IF(SelfDescription__c != &apos;test&apos;  , &apos;test&apos;, &apos;test666&apos;)</formula>
        <name>UpdateEmployeeField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X111</fullName>
        <field>City__c</field>
        <literalValue>哈尔滨市</literalValue>
        <name>111</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>EmpolyeeFieldUpdate</fullName>
        <actions>
            <name>UpdateAccountCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateAccountCityTwo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateAccountFieldTT</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateEmployeeField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Employee__c.Position__c</field>
            <operation>equals</operation>
            <value>employee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
