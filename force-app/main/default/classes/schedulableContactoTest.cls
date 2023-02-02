@isTest
public class schedulableContactoTest {

    @testSetup
    static void makeData(){
        contact contacto1 = new contact(lastName = 'Prueba sin Novedad', Disponibilidad__c = 'Disponible');
        insert contacto1;
        
        contact contacto2 = new contact(lastName = 'Prueba Con Novedad', Disponibilidad__c = 'Disponible');
        insert contacto2;
        
        novedad__c novedadNueva = new novedad__c(Activo__c = true,Fecha_de_inicio__c = date.today(), Fecha_de_finalizacion__c = date.today().addDays(2), Tipo_de_novedad__c ='Incapacidad', Empleado__c = contacto2.Id);
        insert novedadNueva;
    }
    
    @isTest
    public static void cambiarNoDisponible(){
        
        schedulableContacto m = new schedulableContacto();
        test.startTest();
        String sch = '0 0 2 * * ?';
        
        String jobId = System.schedule('testBasicScheduledApex',sch,new schedulableContacto());      
        test.stopTest();
        
        Contact contactoActualizado = [select id, Disponibilidad__c from contact where LastName = 'Prueba Con Novedad'];
        system.assertEquals('No Disponible', contactoActualizado.Disponibilidad__c);
    }
}