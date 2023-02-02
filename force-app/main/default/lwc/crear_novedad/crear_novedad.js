import { LightningElement, api} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CLIENTE_FIELD from '@salesforce/schema/Novedad__c.Cliente__c';
import COMENTARIO_FIELD from '@salesforce/schema/Novedad__c.Comentario__c';
import EMPLEADO_FIELD  from '@salesforce/schema/Novedad__c.Empleado__c';
import FECHA_INICIO_FIELD  from '@salesforce/schema/Novedad__c.Fecha_de_inicio__c';
import FECHA_FINALIZACION_FIELD  from '@salesforce/schema/Novedad__c.Fecha_de_finalizacion__c';
import JORNADA_FIELD  from '@salesforce/schema/Novedad__c.Jornada__c';
import TIPO_NOVEDAD_FIELD  from '@salesforce/schema/Novedad__c.Tipo_de_novedad__c';
import NOVEDAD_OBJECT from '@salesforce/schema/Novedad__c';

export default class Crear_novedad extends LightningElement {
    @api recordId;
    objectApiName = NOVEDAD_OBJECT;
    cliente = CLIENTE_FIELD;
    comentario = COMENTARIO_FIELD;
    empleado = EMPLEADO_FIELD;
    fechaInicio = FECHA_INICIO_FIELD;
    fechaFinalizacion = FECHA_FINALIZACION_FIELD;
    jornada = JORNADA_FIELD;
    tipoNovedad = TIPO_NOVEDAD_FIELD;
    mostrarCampos = false;

    cambiarCampos(event){
        console.log(event.target.value);
        if(event.target.value !== "Asignacion Laboral"){
            this.mostrarCampos = false;
        }else{
            this.mostrarCampos = true;
        }
    }

    handleSuccess(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
        const evt = new ShowToastEvent({
            title: 'Novedad creada',
            message: 'Novedad creada con éxito',
            variant: 'success',

        });      
        this.dispatchEvent(evt);
    }
}