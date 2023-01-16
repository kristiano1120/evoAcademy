public with sharing class Certificacion {

    @AuraEnabled(cacheable = true)
    public static certiWrapper obtenerModulo(string miembroId) {
        Miembro_de_la_cohorte__c miembro = [SELECT id, Name, Cohorte__c FROM Miembro_de_la_cohorte__c WHERE Id =:miembroId LIMIT 1];
        Cohorte__c cohorte = [SELECT Id, Name, Modulo__c FROM Cohorte__c WHERE id =:miembro.Cohorte__c LIMIT 1];
        M_dulo__c modulo = [SELECT id, Name, Certificaci_n__c, Tipo_de_certificaci_n__c FROM M_dulo__c WHERE id =:cohorte.Modulo__c LIMIT 1];
        certiWrapper resultado = new certiWrapper(modulo.Tipo_de_certificaci_n__c, modulo.Certificaci_n__c);
        return resultado;
    }

    public class certiWrapper{
        @AuraEnabled
        public string tipoCertificacion;
        @AuraEnabled
        public string certificacion;

        public certiWrapper(string tipoCertifi, string certifi){
            this.tipoCertificacion = tipoCertifi;
            this.certificacion = certifi;
        }
    }
}