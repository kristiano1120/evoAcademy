@isTest
public class IntentoCertificacionTriggerHandlerTest {
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
    public static void updateName(){
        Intento_de_certificacion__c certificacion = [SELECT ID, name, Certificaciones_Salesforce__c FROM Intento_de_certificacion__c LIMIT 1];
        /* IntentoDeCertificacionTriggerHandler resultado = new IntentoDeCertificacionTriggerHandler.actualizarNombreIntento(certificacion); */
        System.assertEquals('Administrator', certificacion.name);
    }
    
    @isTest
    public static void impedirCertDoble(){
        try{
            List<Miembro_de_la_cohorte__c> miembrosCohorte = [SELECT Id FROM Miembro_de_la_cohorte__c];
            Certificaciones_Salesforce__c certSf = [SELECT Id FROM Certificaciones_Salesforce__c LIMIT 1];
            List<Intento_de_certificacion__c> certificaciones = new List<Intento_de_certificacion__c>();
            for(Miembro_de_la_cohorte__c miembroCoh :  miembrosCohorte){
                Intento_de_certificacion__c certificacion = new Intento_de_certificacion__c( Aprueba__c= true, Certificaciones_Salesforce__c = certSf.Id, Miembro_de_la_cohorte__c = miembroCoh.Id, Name = 'Administrator', Tipo_de_intento__c= 'Certificación');
                certificaciones.add(certificacion);
            }
            insert certificaciones;
            
        }catch(Exception e){
            System.assert(e.getMessage().contains('La certificación que intenta agregar ya fue aprobada por el miembro de la cohorte'));
        }

    }
    
    @isTest
    public static void eliminarCert(){
        List<Intento_de_certificacion__c> listaCert = [SELECT Id FROM Intento_de_certificacion__c];
        List<Intento_de_certificacion__c> undeleteCert = new List<Intento_de_certificacion__c>();
        for(Intento_de_certificacion__c intento: listaCert){
            Intento_de_certificacion__c recuperaCert = new Intento_de_certificacion__c(Id = intento.Id);
            undeleteCert.add(recuperaCert);
        }
        delete listaCert;
        List<Intento_de_certificacion__c> listaElim = [SELECT Id FROM Intento_de_certificacion__c];
        System.assertEquals(0, listaElim.size());
        undelete undeleteCert;
        List<Intento_de_certificacion__c> listaRec = [SELECT Id FROM Intento_de_certificacion__c];
        System.assertEquals(10, listaRec.size());
    }
    
    @isTest
    public static void actualizarCert(){
        List<Intento_de_certificacion__c> listaCert = [SELECT Id FROM Intento_de_certificacion__c];
        List<Intento_de_certificacion__c> actualizarCert = new List<Intento_de_certificacion__c>();
        for(Intento_de_certificacion__c intento: listaCert){
            Intento_de_certificacion__c ActCert = new Intento_de_certificacion__c(Id= intento.Id ,Resultado__c = 76);
            actualizarCert.add(ActCert);
        }
        
        update actualizarCert;
       	List<Intento_de_certificacion__c> resultado = [SELECT Id FROM Intento_de_certificacion__c WHERE Resultado__c = 76];
        system.assertEquals(10, resultado.size());
    }
}