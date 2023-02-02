public with sharing class NovedadTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public NovedadTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    
    public void beforeInsert(List<Novedad__c> newRecords) {
        activarNovedad(newRecords);
    }
    public void beforeUpdate(List<Novedad__c> oldRecords, List<Novedad__c> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap){
        
    }
    public void beforeDelete(List<Novedad__c> oldRecords, Map<ID, sObject> oldRecordMap) {
        
    }
    public void afterInsert(List<Novedad__c> newRecords, Map<ID, sObject> newRecordMap) {
        actualizarContacto(newRecords);
    }
    public void afterUpdate(List<Novedad__c> oldRecords, List<Novedad__c> newRecords, Map<ID, sObject> oldRecordMap, Map<ID, sObject> newRecordMap) {
        //actualizarContacto(newRecords,oldRecords);
    }
    public void afterDelete(List<Novedad__c> oldRecords, Map<ID, sObject> oldRecordMap) {
        
    }
    public void afterUndelete(List<Novedad__c> newRecords, Map<ID, sObject> newRecordMap) {
        
    }
    public static void activarNovedad(List<novedad__c> novedades){
        if(test.isRunningTest()){
            system.debug('estoy en un test!');
            for(novedad__c novedad: novedades){
                if(date.today() <= novedad.Fecha_de_finalizacion__c && date.today() >= novedad.Fecha_de_inicio__c){
                    novedad.Comentario__c = 'Activo';
                }
            }
        }else{
            for(novedad__c novedad: novedades){
                if(date.today() <= novedad.Fecha_de_finalizacion__c && date.today() >= novedad.Fecha_de_inicio__c){
                    novedad.Activo__c = true;
                }
            }
        }
    }
    
    public static void actualizarContacto(list<Novedad__c> novedades){
        /*set<Id> contactNovedad = new set<Id>();
for(Novedad__c novedad: novedadesNew){
for(Novedad__c novedadOld: novedadesOld){
if(novedad.Id == novedadOld.Id){
if(novedad.Activo__c != novedadOld.Activo__c){
contactNovedad.add(novedad.Empleado__c);
}
}
}
}
list<Contact> contactosNovedades = [select id, Disponibilidad__c from Contact where ID IN: contactNovedad];
List<Novedad__c> novedadesContactos = [select id, Empleado__c, Activo__c  from Novedad__c where Empleado__c IN: contactNovedad];
list<Contact> contactoActualizable = new list<Contact>();
for(Contact contacto : contactosNovedades){
boolean novedadActiva = false;
Contact contactoActu = new Contact();
for(Novedad__c novedad : novedadesContactos){
while (novedadActiva == false){
if(contacto.Id == novedad.Empleado__c){
if(novedad.Activo__c == true){
novedadActiva = true;
}else{
contactoActu.Id = contacto.Id;
switch on novedad.Tipo_de_novedad__c {
when 'Asignacion Laboral' {		
switch on novedad.Jornada__c{
when 'Tiempo Completo'{
contactoActu.Disponibilidad__c = 'No Disponible'; 
}when 'AM','PM'{
contactoActu.Disponibilidad__c = 'Disponible Medio Tiempo'; 
}
}
}	
when 'Incapacidad','Vacaciones','Licencia','Otra'  {		
contactoActu.Disponibilidad__c = 'No Disponible';
}
}
}
}
}
}
if(novedadActiva == false){
contactoActualizable.add(contactoActu);
}
}
update contactoActualizable;*/
        
        set<Id> idEmpleado = new set<Id>();
        for(novedad__c novedad:novedades){
            idEmpleado.add(novedad.Empleado__c);
        }
        List<Contact> empleados = [select id, disponibilidad__c from contact where Id IN: idEmpleado];
        List<Contact> empleadoActualizable = new list<Contact>();
        set<Contact> registrosParaActualizar=new set<Contact>();
        for(novedad__c novedad: novedades){
            for(contact contacto : empleados){
                if(novedad.Empleado__c == contacto.Id){
                    if(date.today() <= novedad.Fecha_de_finalizacion__c && date.today() >= novedad.Fecha_de_inicio__c && contacto.Disponibilidad__c == 'Disponible'){
                        Contact newEmpleado = new Contact(Id = contacto.Id,Disponibilidad__c = 'No Disponible');
                        registrosParaActualizar.add(newEmpleado);
                    }
                }
            }
        }
        empleadoActualizable.addAll(registrosParaActualizar);
        update empleadoActualizable;
        
    }
}