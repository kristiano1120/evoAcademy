public class HorarioLaboralTriggerHandler implements TriggerHandler{
	private boolean triggerIsExecuting;
    private integer triggerSize;
    public HorarioLaboralTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    
    public void beforeInsert(List<OperatingHours> newRecords) {
        //noRepetirPrerrequisito(newRecords);
    }
    public void beforeUpdate(List<OperatingHours> oldRecords, List<OperatingHours> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap){
        //
    }
    public void beforeDelete(List<OperatingHours> oldRecords, Map<ID, sObject> oldRecordMap) {
        // helper.doTask5();
        // helper.doTask1();
    }
    public void afterInsert(List<OperatingHours> newRecords, Map<ID, sObject> newRecordMap) {
        // helper.doTask2();
        // helper.doTask3();
    }
    public void afterUpdate(List<OperatingHours> oldRecords, List<OperatingHours> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap) {
        //
    }
    public void afterDelete(List<OperatingHours> oldRecords, Map<ID, sObject> oldRecordMap) {
        // helper.doTask3();
        // helper.doTask1();
    }
    public void afterUndelete(List<OperatingHours> newRecords, Map<ID, sObject> newRecordMap) {
        // helper.doTask4();
        // helper.doTask2();
    }
}