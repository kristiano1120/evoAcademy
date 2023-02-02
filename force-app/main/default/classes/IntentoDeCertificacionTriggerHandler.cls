public with sharing class IntentoDeCertificacionTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public IntentoDeCertificacionTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Intento_de_certificacion__c> newRecords) {
        actualizarNombreIntento(newRecords);
        igualRecordType(newRecords);
        sinDobleCertificacion(newRecords);
        
    }
    public void beforeUpdate(List<Intento_de_certificacion__c> oldRecords, List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap){
        actualizarNombreIntento(newRecords);
    }
    public void beforeDelete(List<Intento_de_certificacion__c> oldRecords, Map<ID, sObject> oldRecordMap) {

    }
    public void afterInsert(List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> newRecordMap) {
        crearResultadosSeccion(newRecords);
    }
    public void afterUpdate(List<Intento_de_certificacion__c> oldRecords, List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap) {
        
    }
    public void afterDelete(List<Intento_de_certificacion__c> oldRecords, Map<ID, sObject> oldRecordMap) {

    }
    public void afterUndelete(List<Intento_de_certificacion__c> newRecords, Map<ID, sObject> newRecordMap) {

    }

    public static void actualizarNombreIntento(List<Intento_de_certificacion__c> intentos) {
        /* String numRandom = EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128)).substring(0,6);
                opp.Name = Titulares.get(opp.Titular_de_la_reserva__c).name + '-' + NumeroDeReserva; */
        Set<Id> certificadosId = new set<Id>();
        for (Intento_de_certificacion__c i : intentos) {
            certificadosId.add(i.Certificaciones_Salesforce__c);
        }
        Map<Id, Certificaciones_Salesforce__c>  certis = new Map<Id, Certificaciones_Salesforce__c>([SELECT Name FROM Certificaciones_Salesforce__c WHERE Id = : certificadosId]);

        for (Intento_de_certificacion__c intento : intentos) {
            intento.Name = certis.get(intento.Certificaciones_Salesforce__c).name;
        }    
    }

    public static void crearResultadosSeccion(List<Intento_de_certificacion__c> intentos) {
        set <Id> intentosId = new set<Id>();
        for(Intento_de_certificacion__c intento : intentos){
            intentosId.add(intento.Certificaciones_Salesforce__c);
        }
        
        List<Resultado_de_secci_n__c> resultados = new List<Resultado_de_secci_n__c>();

        List<secciones_de_certificacion__c> secciones = [SELECT Id, Name, Certificaciones_Salesforce__r.Name FROM secciones_de_certificacion__c 
                                                        WHERE Certificaciones_Salesforce__c in : intentosId];

        for (Intento_de_certificacion__c intento : intentos) {
            for (secciones_de_certificacion__c sec : secciones) {
                if (intento.Certificaciones_Salesforce__c == sec.Certificaciones_Salesforce__c) {
                    Resultado_de_secci_n__c resultado = new Resultado_de_secci_n__c();
                    resultado.Certificaci_n__c = intento.Id;
                    resultado.Secciones_de_certificaci_n__c = sec.Id;
                    resultado.Resultado__c = 0;
                    resultados.add(resultado); 
                }
            }
        }
        insert resultados;

        
    }

    public static void igualRecordType(List<Intento_de_certificacion__c> intentos){
        List<RecordType> idSimulacro = [select id from RecordType where name = 'Simulacro de certificación' limit 1];
        for (Intento_de_certificacion__c inte : intentos) {
            if (inte.Tipo_de_intento__c == 'Simulacro de certificación') {
                inte.RecordTypeId = idSimulacro[0].Id;
            }
        }
    }
    
    public static void sinDobleCertificacion(List<Intento_de_certificacion__c> intentosCert){
        try{
            Set<Id> miembrosCohorte = new Set<Id>();
            for(Intento_de_certificacion__c intentoCert : intentosCert){
                if((intentoCert.Aprueba__c == true) && (intentoCert.Tipo_de_intento__c == 'Certificación')){
                    miembrosCohorte.add(intentoCert.Miembro_de_la_cohorte__c);
                }
            }
            
            if(miembrosCohorte != null){
                List<Intento_de_certificacion__c> certExistentes = [SELECT Id, Miembro_de_la_cohorte__c, Certificaciones_Salesforce__c, Aprueba__c, Tipo_de_intento__c FROM Intento_de_certificacion__c WHERE  Miembro_de_la_cohorte__c IN: miembrosCohorte];
                for(Intento_de_certificacion__c certExistente : certExistentes){
                    for(Intento_de_certificacion__c intentoCert : intentosCert){
                        if((certExistente.Miembro_de_la_cohorte__c == intentoCert.Miembro_de_la_cohorte__c) && (certExistente.Certificaciones_Salesforce__c == intentoCert.Certificaciones_Salesforce__c)){
                            if((intentoCert.Aprueba__c == certExistente.Aprueba__c) && (intentoCert.Tipo_de_intento__c == 'Certificación' && certExistente.Tipo_de_intento__c == 'Certificación')){
                                intentoCert.Certificaciones_Salesforce__c.addError('La certificación que intenta agregar ya fue aprobada por el miembro de la cohorte');
                            }
                        }else{
                            System.debug('No coinciden: ' + certExistente.Miembro_de_la_cohorte__c + ' con ' + intentoCert.Miembro_de_la_cohorte__c);
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('Error ' + e.getMessage());
        }
    }

}