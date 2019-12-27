public with sharing class PicklistDescriber {
	static final Pattern OPTION_PATTERN = Pattern.compile('<option.+?>(.+?)</option>'); 
	static List<String> parseOptions(Map<String, String> params) {
		Pagereference pr = Page.PicklistDesc;
		// to handle development mode, if ON
		pr.getParameters().put('core.apexpages.devmode.url', '1');
		
		for (String key : params.keySet()) {
			pr.getParameters().put(key, params.get(key));	
		}
		
		String xmlContent = pr.getContent().toString();
		
		Matcher mchr = OPTION_PATTERN.matcher(xmlContent);
		List<String> options = new List<String>();
		while(mchr.find()) {
			options.add(mchr.group(1));
		} 
		// remove the --None-- element
		if (!options.isEmpty()) options.remove(0);
		return options;
	}

	public static List<String> describe(Id sobjectId, String pickListFieldAPIName) {
		return parseOptions(
							new Map<String, String>	{
													 'id' => sobjectId,
													 'pickListFieldName'=> pickListFieldAPIName
													}
							);
	}

	public static List<String> describe(String sobjectType, Id recordTypeId, String pickListFieldAPIName) {
		return parseOptions(
							new Map<String, String>	{
													 'sobjectType' => sobjectType,
													 'recordTypeId' => recordTypeId,
													 'pickListFieldName'=> pickListFieldAPIName
													}
							);
	}
	public static List<String> describe(String sobjectType, String recordTypeName, String pickListFieldAPIName) {
		return parseOptions(
							new Map<String, String>	{
													 'sobjectType' => sobjectType,
													 'recordTypeName' => recordTypeName,
													 'pickListFieldName'=> pickListFieldAPIName
													}
							);
	}
    
}