/**
 * Created by meixing on 2019-10-06.
 */
({
    calculateDate : function(component, period) {
        var startDateString = period.substring(0, period.indexOf("-"));
        var endDateString = period.substring(period.indexOf("-") +1);

        console.log("startDateString", startDateString, "endDateString", endDateString);

        component.set("v.startDate", $A.localizationService.formatDate(new Date(startDateString), "YYYY-MM-DD"));
        component.set("v.endDate", $A.localizationService.formatDate(new Date(endDateString), "YYYY-MM-DD"));

        console.log(new Date(startDateString), new Date(endDateString));
    },

    calculatePeriod : function(component) {
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");

        return $A.localizationService.formatDate(startDate, "YYYY.MM.DD") + "-" +
                $A.localizationService.formatDate(endDate, "YYYY.MM.DD");
    },

})