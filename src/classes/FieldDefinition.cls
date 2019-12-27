/**
 * Class used to serialize a single Schema.DescribeFieldResult
 *
 @author  Mei Xing
 @created 2019-05-07
 @version 1.0
 @since   43.0 (Force.com ApiVersion)
 *
 @changelog
 * 2019-05-07  Mei Xing <mei.xing@capgemini.com>
 * - Created
 */
public class FieldDefinition {

    private Integer byteLength;
    private String  calculatedFormula;
    private String  controller;
    private Object  defaultValue;
    private String  defaultValueFormula;
    private Integer digits;
    private String  inlineHelpText;
    private String  label;
    private Integer length;
    private String  localName;
    private String  name;
    private List<Map<String,String>> picklistValues;
    private Integer precision;
    private String  referenceTargetField;
    private List<String>  referenceTo;
    private String  relationshipName;
    private Integer relationshipOrder;
    private Double scale;
    private String type;

    @AuraEnabled
    public Boolean isAccessible;
    @AuraEnabled
    public Boolean isAutoNumber;
    @AuraEnabled
    public Boolean isCalculated;
    @AuraEnabled
    public Boolean isCascadeDelete;
    @AuraEnabled
    public Boolean isCaseSensitive;
    @AuraEnabled
    public Boolean isCreateable;
    @AuraEnabled
    public Boolean isCustom;
    @AuraEnabled
    public Boolean isDefaultedOnCreate;
    @AuraEnabled
    public Boolean isDependentPicklist;
    @AuraEnabled
    public Boolean isExternalID;
    @AuraEnabled
    public Boolean isFilterable;
    @AuraEnabled
    public Boolean isFormulaTreatNullNumberAsZero;
    @AuraEnabled
    public Boolean isGroupable;
    @AuraEnabled
    public Boolean isHtmlFormatted;
    @AuraEnabled
    public Boolean isIdLookup;
    @AuraEnabled
    public Boolean isNameField;
    @AuraEnabled
    public Boolean isNamePointing;
    @AuraEnabled
    public Boolean isNillable;
    @AuraEnabled
    public Boolean isPermissionable;
    @AuraEnabled
    public Boolean isRestrictedDelete;
    @AuraEnabled
    public Boolean isRestrictedPicklist;
    @AuraEnabled
    public Boolean isSearchPrefilterable;
    @AuraEnabled
    public Boolean isSortable;
    @AuraEnabled
    public Boolean isUnique;
    @AuraEnabled
    public Boolean isUpdateable;
    @AuraEnabled
    public Boolean isWriteRequiresMasterRead;

    public FieldDefinition(Schema.DescribeFieldResult dfr) {
        this.byteLength = dfr.byteLength;
        this.calculatedFormula = dfr.calculatedFormula;
        this.controller = dfr.controller != null ? dfr.controller.getDescribe().name : '';
        this.defaultValue = dfr.defaultValue;
        this.defaultValueFormula = dfr.defaultValueFormula;
        this.digits = dfr.digits;
        this.inlineHelpText = dfr.inlineHelpText;
        this.label = dfr.label;
        this.length = dfr.length;
        this.localName = dfr.localName;
        this.name = dfr.name;
        this.picklistValues = ClsPicklistService.convertEntries(dfr.picklistValues);
        this.precision = dfr.precision;
        this.referenceTargetField = dfr.referenceTargetField;
        //this.referenceTo = dfr.referenceTo.getSObjectType().getDescribe().name;
        this.relationshipName = dfr.relationshipName;
        this.relationshipOrder = dfr.relationshipOrder;
        this.scale = Math.pow(10, -1 * dfr.scale);
        this.type = String.valueOf(dfr.type).toLowerCase();

        this.isAccessible = dfr.isAccessible();
        this.isAutoNumber = dfr.isAutoNumber();
        this.isCalculated = dfr.isCalculated();
        this.isCascadeDelete = dfr.isCascadeDelete();
        this.isCaseSensitive = dfr.isCaseSensitive();
        this.isCreateable = dfr.isCreateable();
        this.isCustom = dfr.isCustom();
        this.isDefaultedOnCreate = dfr.isDefaultedOnCreate();
        this.isDependentPicklist = dfr.isDependentPicklist();
        this.isFilterable = dfr.isFilterable();
        this.isFormulaTreatNullNumberAsZero = dfr.isFormulaTreatNullNumberAsZero();
        this.isGroupable = dfr.isGroupable();
        this.isHtmlFormatted = dfr.isHtmlFormatted();
        this.isIdLookup = dfr.isIdLookup();
        this.isNameField = dfr.isNameField();
        this.isNamePointing = dfr.isNamePointing();
        this.isNillable = dfr.isNillable();
        this.isPermissionable = dfr.isPermissionable();
        this.isRestrictedDelete = dfr.isRestrictedDelete();
        this.isRestrictedPicklist = dfr.isRestrictedPicklist();
        this.isSearchPrefilterable = dfr.isSearchPrefilterable();
        this.isSortable = dfr.isSortable();
        this.isUnique = dfr.isUnique();
        this.isUpdateable = dfr.isUpdateable();
        this.isWriteRequiresMasterRead = dfr.isWriteRequiresMasterRead();



    }

    @AuraEnabled
    public Integer getByteLength() {
        return this.byteLength;
    }

    @AuraEnabled
    public String getCalculatedFormula() {
        return this.calculatedFormula;
    }

    @AuraEnabled
    public String getController() {
        return this.controller;
    }

    @AuraEnabled
    public Object getDefaultValue() {
        return this.defaultValue;
    }

    @AuraEnabled
    public String getDefaultValueFormula() {
        return this.defaultValueFormula;
    }

    @AuraEnabled
    public Integer getDigits() {
        return this.digits;
    }

    @AuraEnabled
    public String getInlineHelpText() {
        return this.inlineHelpText;
    }

    @AuraEnabled
    public String getLabel() {
        return this.label;
    }

    @AuraEnabled
    public Integer getLength() {
        return this.length;
    }

    @AuraEnabled
    public String getLocalName() {
        return this.localName;
    }

    @AuraEnabled
    public String getName() {
        return this.name;
    }

    @AuraEnabled
    public List<Map<String,String>> getPicklistValues() {
        return this.picklistValues;
    }

    @AuraEnabled
    public Integer getPrecision() {
        return this.precision;
    }

    @AuraEnabled
    public String getReferenceTargetField() {
        return this.referenceTargetField;
    }

    /*@AuraEnabled
    public String getReferenceTo() {
        return this.referenceTo;
    }*/

    @AuraEnabled
    public String getRelationshipName() {
        return this.relationshipName;
    }

    @AuraEnabled
    public Integer getRelationshipOrder() {
        return this.relationshipOrder;
    }

    @AuraEnabled
    public Double getScale() {
        return this.scale;
    }

    @AuraEnabled
    public String getType() {
        return this.type;
    }

    /**
    * the method to get field definition
      @param objectType      object api
      @param fieldSetName     fieldset api name
      @return Map<String,FieldDefinition> return map field definition
      @author Mei Xing
      @created 2018-12-24
    **/
    public static Map<String,FieldDefinition> getFieldMapByFieldSet(String objectType, String fieldSetName){
        Schema.FieldSet fieldset = Schema.getGlobalDescribe().get(objectType).getDescribe().fieldSets.getMap().get(fieldSetName);
        Map<String,FieldDefinition> map_fieldMap = new Map<String,FieldDefinition>();

        if(fieldset != null){

            for(Schema.FieldSetMember fieldMember : fieldset.getFields()){
                if(!fieldMember.getFieldPath().contains('.')){
                    map_fieldMap.put(fieldMember.getFieldPath(), new FieldDefinition(Schema.getGlobalDescribe().get(objectType).getDescribe().fields.getMap().get(fieldMember.getFieldPath()).getDescribe()));
                }
            }
        }

        return map_fieldMap;
    }
}