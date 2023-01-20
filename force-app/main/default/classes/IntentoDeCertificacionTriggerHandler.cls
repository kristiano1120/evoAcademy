public with sharing class IntentoDeCertificacionTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public IntentoDeCertificacionTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Intento_de_certificacion__c> newRecords) {
        actualizarNombreIntento(newRecords);
    }
    public void beforeUpdate(List<Intento_de_certificacion__c> oldRecords, List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap){
        actualizarNombreIntento(newRecords);
    }
    public void beforeDelete(List<Intento_de_certificacion__c> oldRecords, Map<ID, sObject> oldRecordMap) {

    }
    public void afterInsert(List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> newRecordMap) {

    }
    public void afterUpdate(List<Intento_de_certificacion__c> oldRecords, List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap) {
        
    }
    public void afterDelete(List<Intento_de_certificacion__c> oldRecords, Map<ID, sObject> oldRecordMap) {

    }
    public void afterUndelete(List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> newRecordMap) {

    }

    public static void actualizarNombreIntento(List<Intento_de_certificacion__c> intentos) {

        for (Intento_de_certificacion__c intento : intentos) {
            intento.Name = intento.Certificaci_n__c;
        }    
    }

}