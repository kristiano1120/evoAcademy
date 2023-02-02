public class schedulableContacto implements Schedulable{
    
    public void execute(SchedulableContext ctx){
        List<Contact> contactos = [select id, Disponibilidad__c from contact];
        set<id> idContact = new set<id>();
        for(contact contacto :contactos){
            idContact.add(contacto.Id);
        }
        list<Novedad__c> novedadesContacto = [select id, Activo__c, Empleado__c from Novedad__c where Empleado__c IN: idContact];
        List<Contact> contactoActualizable = new list<Contact>();
        for(contact contacto : contactos){
            Contact nuevoContacto = new contact(id = contacto.Id,Disponibilidad__c = 'Disponible');
            for(Novedad__c novedad : novedadesContacto){
                if(contacto.Id == novedad.Empleado__c){
                    if(novedad.Activo__c == true){
                        nuevoContacto.Disponibilidad__c = 'No Disponible';
                    }
                }
            }
            contactoActualizable.add(nuevoContacto);
        }
        
        try{
            update contactoActualizable;
        }catch(exception e){
            throw new ErrorException(e);
        }
    }
    
    public class ErrorException extends Exception{}
}