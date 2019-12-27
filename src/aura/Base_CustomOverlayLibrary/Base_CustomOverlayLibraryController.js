/**
 * 2018/10/12  Zhuoxue Jin <zhuoxue.jin@capgemini.com>
 * - Created
 */

({
    /**
    * Action handler for showCustomModal
    **/
    handleShowCustomModalAction : function(component,event,helper){

        //console.log('handleCloseAction In');
        var params = event.getParam('arguments').modalParams;

        component.set("v.header", params.header);
        component.set("v.body", params.body);
        component.set("v.footer", params.footer);
        component.set("v.showCloseButton", params.showCloseButton);
        component.set("v.cssClass", params.cssClass);
        component.set("v.closeCallback", params.closeCallback);

        component.set("v.hidden", false);
    },
    /**
    * Action handler for showCustomModal
    **/
    handleShowCustomPopoverAction : function(component,event,helper){

        var params = event.getParam('arguments');
        var params = event.getParam('arguments');
        component.set("v.header", params.header);
        component.set("v.body", params.body);
        component.set("v.footer", params.footer);
        component.set("v.showCloseButton", params.showCloseButton);
        component.set("v.cssClass", params.cssClass);
        component.set("v.closeCallback", params.closeCallback);

        component.set("v.hidden", false);
    },
    /**
    * Action handler for showCustomModal
    **/
    handleCloseAction : function(component,event,helper){

        //console.log('handleCloseAction In');
        component.set("v.hidden", true);
    },
    /**
    * Action handler for showCustomModal
    **/
    handleHideAction : function(component,event,helper){

        //console.log('handleHideAction In');
        component.set("v.hidden", true);
    },
    /**
    * Action handler for showCustomModal
    **/
    handleShowAction : function(component,event,helper){

        //console.log('handleShowAction In');

        component.set("v.hidden", false);
    }
})