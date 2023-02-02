public class schedulableNovedad implements Schedulable{
    
    public void execute(SchedulableContext ctx){
        List<Novedad__c> novedades = [select id, Empleado__c , Tipo_de_novedad__c, Jornada__c, Activo__c , Fecha_de_inicio__c, Fecha_de_finalizacion__c   from Novedad__c ];
        list<Novedad__c> novedadesActualizables= new list<Novedad__c>();
        
        for(Novedad__c novedad: novedades){
            if(date.today() <= novedad.Fecha_de_finalizacion__c && date.today() >= novedad.Fecha_de_inicio__c && novedad.Activo__c != true){
                novedad__c nuevaNovedad = new novedad__C();
                nuevaNovedad.Id = novedad.Id;
                nuevaNovedad.Activo__c = true;
                novedadesActualizables.add(nuevaNovedad);
            }else if(date.today() <= novedad.Fecha_de_finalizacion__c && date.today() >= novedad.Fecha_de_inicio__c && novedad.Activo__c != false){
                
            }else{
                novedad__c nuevaNovedad = new novedad__C();
                nuevaNovedad.Id = novedad.Id;
                nuevaNovedad.Activo__c = false;
                novedadesActualizables.add(nuevaNovedad);
            }
        }
        try{
            update novedadesActualizables;
        }catch(exception e){
            throw new ErrorException(e);
        }
        
    }
    
    public class ErrorException extends Exception{}
}