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

    @AuraEnabled
    public static List<secciones> obtenerSecciones(string certificado){
        try {
            Certificaciones_Salesforce__c certiSalesforce = [SELECT Id, Name FROM Certificaciones_Salesforce__c WHERE Name =: certificado LIMIT 1];
            List<secciones_de_certificacion__c> secciones = [SELECT Id, Name, Certificaciones_Salesforce__r.name FROM secciones_de_certificacion__c WHERE Certificaciones_Salesforce__c =: certiSalesforce.Id];
            List<secciones> seccionesRta = new List<secciones>();
            for (secciones_de_certificacion__c sc : secciones) {
                seccionesRta.add(new secciones(sc.id ,sc.Name, sc.Certificaciones_Salesforce__r.name));
            }
            system.debug(seccionesRta);
            return seccionesRta;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void SaveSecciones(List<secciones_de_certificacion__c> seccionesComp, string idCertiNueva){
        try {
            List<secciones_de_certificacion__c> seccionesRecu = new List<secciones_de_certificacion__c>();
            for (secciones_de_certificacion__c sec : seccionesComp) {
                secciones_de_certificacion__c s= new secciones_de_certificacion__c();
                s.Name = sec.Name;
                s.Certificaciones_Salesforce__c = idCertiNueva;
                seccionesRecu.add(s);
            }
            insert seccionesRecu;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class secciones 
    {
        @AuraEnabled 
        public string idsecc {get;set;} 
        @AuraEnabled 
        public string nombresecc {get;set;}
        @AuraEnabled 
        public string certificacionsecc {get;set;}

        public secciones(string id,string nombre, string certificacion){
            nombresecc = nombre;
            certificacionsecc = certificacion;
            idsecc = id;
        }
    }
}