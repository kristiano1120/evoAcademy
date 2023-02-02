@isTest
public with sharing class CertificacionTest {
    
    @TestSetup
    static void makeData(){
        Habilidad__c habilidad = new Habilidad__c(Name = 'Administrator');
        insert habilidad;
        
        List<Contact> contactos = new List<Contact>();
        for(Integer i = 0; i < 10; i++){
            Contact nuevoContacto = new Contact(LastName = 'Prueba' + i, RecordTypeId = '012Dn0000006c0RIAQ');
            contactos.add(nuevoContacto);
        }
        insert contactos;
        
        M_dulo__c modulo = new M_dulo__c(Intentos_de_certificacion_permitidos__c = 3, Name= 'Administrator', Certificaci_n__c = 'Administrator', Tipo_de_certificaci_n__c = 'Administrator');
        insert modulo;
        
        Cohorte__c cohorte = new Cohorte__c(Fecha_de_inicio__c= Date.newInstance(2023, 02, 15), Modulo__c = modulo.Id);
        insert cohorte;
        
        List<Miembro_de_la_cohorte__c> miembrosCohorte = new List<Miembro_de_la_cohorte__c>();
       	for(Contact contacto : contactos){
            Miembro_de_la_cohorte__c miembroCohorte = new Miembro_de_la_cohorte__c(Cohorte__c = cohorte.Id, Empleado__c = contacto.Id);
            miembrosCohorte.add(miembroCohorte);
        }
        
        insert miembrosCohorte;
        
        Certificaciones_Salesforce__c certSf = new Certificaciones_Salesforce__c(Name = 'Administrator');
        insert certSf;

        List<secciones_de_certificacion__c> secciones = new List<secciones_de_certificacion__c>();
        secciones.add(new secciones_de_certificacion__c(Name = 'Configuration and Setup',Certificaciones_Salesforce__c = certSf.Id));
        secciones.add(new secciones_de_certificacion__c(Name = 'Sales and Marketing Applications',Certificaciones_Salesforce__c = certSf.Id));
        secciones.add(new secciones_de_certificacion__c(Name = 'Object Manager and Lightning App Builder',Certificaciones_Salesforce__c = certSf.Id));
        secciones.add(new secciones_de_certificacion__c(Name = 'Workflow/Process Automation',Certificaciones_Salesforce__c = certSf.Id));
        secciones.add(new secciones_de_certificacion__c(Name = 'Service and Support Applications',Certificaciones_Salesforce__c = certSf.Id));
        secciones.add(new secciones_de_certificacion__c(Name = 'Productivity and Collaboration',Certificaciones_Salesforce__c = certSf.Id));
        secciones.add(new secciones_de_certificacion__c(Name = 'Data and analytics management',Certificaciones_Salesforce__c = certSf.Id));
        insert secciones;
        
        List<Intento_de_certificacion__c> certificaciones = new List<Intento_de_certificacion__c>();
        for(Miembro_de_la_cohorte__c miembroCoh :  miembrosCohorte){
            Intento_de_certificacion__c certificacion = new Intento_de_certificacion__c( Aprueba__c= true, Certificaciones_Salesforce__c = certSf.Id, Miembro_de_la_cohorte__c = miembroCoh.Id, Tipo_de_intento__c= 'Certificación');
            certificaciones.add(certificacion);
        }
        insert certificaciones;
    }

    @isTest
    public static void obtenerModulo(){
        Miembro_de_la_cohorte__c miembroPrueba = [SELECT id FROM Miembro_de_la_cohorte__c LIMIT 1];
        Certificacion.certiWrapper resultado = Certificacion.obtenerModulo(miembroPrueba.id);
        System.assertEquals('Administrator', resultado.tipoCertificacion);
        System.assertEquals('Administrator', resultado.certificacion);
    }

    @isTest
    public static void getSecciones(){
        Intento_de_certificacion__c intento = [SELECT id FROM Intento_de_certificacion__c LIMIT 1];
        List<Resultado_de_secci_n__c> seccionesRecu = Certificacion.getSecciones(intento.id);
        System.assertEquals(7,seccionesRecu.size());
        
    }

}