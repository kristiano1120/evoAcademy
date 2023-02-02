@isTest
public class schedulableNovedadTest {
    
    @testSetup
    static void makeData(){
        Contact contacto = new Contact(lastName = 'Aguirre',disponibilidad__c = 'Disponible');
        insert contacto;
        contacto = [SELECT Id, lastName From Contact Limit 1];
        
        list<novedad__c> nuevasNovedades =new list<novedad__c>();
        for(integer i = 0; i < 9 ; i++){
            if(i<3){
                novedad__c novedad = new novedad__c();
                novedad.Fecha_de_inicio__c = date.today();
                novedad.Fecha_de_finalizacion__c = date.today().addDays(2);
                novedad.Tipo_de_novedad__c = 'Incapacidad';
                novedad.Empleado__c = contacto.Id;
                novedad.Activo__c = false;
                
                nuevasNovedades.add(novedad);
            }else if(i>2 && i <6){
                novedad__c novedad = new novedad__c();
                novedad.Fecha_de_inicio__c = date.today().addDays(2);
                novedad.Fecha_de_finalizacion__c = date.today().addDays(3);
                novedad.Tipo_de_novedad__c = 'Incapacidad';
                novedad.Empleado__c = contacto.Id;
                novedad.Activo__c = false;
                
                nuevasNovedades.add(novedad);
            }else{
                novedad__c novedad = new novedad__c();
                novedad.Fecha_de_inicio__c = date.today().addDays(-3);
                novedad.Fecha_de_finalizacion__c = date.today().addDays(3);
                novedad.Tipo_de_novedad__c = 'Incapacidad';
                novedad.Empleado__c = contacto.Id;
                novedad.Activo__c = false;
                
                nuevasNovedades.add(novedad);
            }
            
        }
        insert nuevasNovedades;
        list<Novedad__c> novedades3 = [select id, activo__c from Novedad__c];
        system.debug('makeup'+novedades3);
    }
    
    @isTest
    static void novedadActiva(){
        list<Novedad__c> novedades3 = [select id, activo__c from Novedad__c];
        system.assertEquals(9, novedades3.size());
        system.debug('antes del test'+novedades3);
        
        schedulableNovedad m = new schedulableNovedad();
        test.startTest();
        String sch = '0 0 1 * * ?';
        
        String jobId = System.schedule('testBasicScheduledApex',sch,new schedulableNovedad());      
        test.stopTest();
        
        list<Novedad__c> novedades2 = [select id, activo__c from Novedad__c where activo__c = true ];
        system.assertEquals(6, novedades2.size());
        system.debug('fuera de Test '+novedades2);
        
        list<Novedad__c> novedades5 = [select id, activo__c from novedad__c where activo__c = false];
        system.assertEquals(3, novedades5.size());
        
        list<Novedad__c> novedadesTrigger = [select id, activo__c, comentario__c FROM Novedad__c WHERE Fecha_de_inicio__c =: date.today()];
        system.assert(novedadesTrigger[0].comentario__c.contains('Activo'));
    }
    
    @isTest
    static void contactoNoDisponible(){
        Contact contactoActualizado = [select id, disponibilidad__c from contact limit 1];
        
        system.assertEquals('No Disponible', contactoActualizado.disponibilidad__c);
    }
    
    @isTest
    static void deleteUndeleteNovedad(){
        list<novedad__c> novedades = [select id from novedad__c];
        Id novedadBorrable = novedades[0].id;
        
        system.assertEquals(9, novedades.size());
        delete novedades[0];
        
        list<novedad__c> novedades1 = [select id from novedad__c];
        system.assertEquals(8, novedades1.size());
        
        novedad__c undeleteContact = new novedad__c(id= novedadBorrable);
        undelete undeleteContact;
        
         list<novedad__c> novedades2 = [select id from novedad__c];
        system.assertEquals(9, novedades2.size());
    }
}