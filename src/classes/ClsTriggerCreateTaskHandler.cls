public with sharing class ClsTriggerCreateTaskHandler  extends ClsTriggerVirtual{
	/**
     * @see IntHelper.beforeTrigger
     */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {

        createTask(trgCtx);
    }

    public static void createTask (ClsWrappers.TriggerContext trgCtx) {
    	List<Task> taskList = new List<Task>();
    	if (trgCtx.isInsert) {
    		List<Case> targetCase = getTargetCase(trgCtx);
    		System.debug('targetCase----------->' + targetCase);

    		Group targetGroup = [Select id,Name,DeveloperName from group where DeveloperName = 'TestT'];

    		for (Case newcase : targetCase) {
    			Task task = new Task();
    			task.WhatId = newcase.Id;
    			task.Priority = 'Normal';
    			task.Status = 'Not Start';
    			task.OwnerId = '03g2v000000GHKD';
    			taskList.add(task);
    		}
    	}

    	insert taskList;
    	System.debug('taskList--------------->' + taskList);
    }

    public static List<Case> getTargetCase (ClsWrappers.TriggerContext trgCtx) {
    	List<Case> resultCaseList = new List<Case>();
    	for (Case newcase : (List<Case>)trgCtx.newList) {
    		if (newcase.Priority == 'High' && newcase.Status == 'New') {
    			resultCaseList.add(newcase);
    		}
    	}

    	return resultCaseList;
    } 
    
}
/*
&& newcase.CreatedDate <= Datetime.now() && newcase.CreatedDate >= Datetime.now() - 3
*/