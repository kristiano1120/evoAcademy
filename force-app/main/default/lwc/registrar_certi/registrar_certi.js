import {api, track, LightningElement, wire } from 'lwc';

import registrar from '@salesforce/apex/Certificacion.obtenerModulo';
import secciones from '@salesforce/apex/Certificacion.obtenerSecciones';
import savesec from '@salesforce/apex/Certificacion.SaveSecciones';

import TIPOC from '@salesforce/schema/Intento_de_certificacion__c.Tipo_de_certificaci_n__c';
import CERTI from '@salesforce/schema/Intento_de_certificacion__c.Certificaci_n__c';
import MIEMBRO from '@salesforce/schema/Intento_de_certificacion__c.Miembro_de_la_cohorte__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Sección de Certificación', fieldName: 'nombresecc', type: 'text', editable: true},
    { label: 'Certificación', fieldName: 'certificacionsecc', type: 'text', editable: true},
    { label: 'Resultado', fieldName: 'Resultadosecc', type: 'number', editable: true},
];

export default class Registrar_certi extends LightningElement {
    @api recordId;
    certif;
    tipocer;
    certificacion = CERTI;
    tipoCerti = TIPOC;
    miembro = MIEMBRO;
    modalTabla = false;
    modalIntento = true;
    valorSeleccionado;
    recordId;
    action;
    row;
    fldsItemValues= [];

    data;
    columns = columns;
    rowOffset = 0;

        @wire(registrar, {miembroId: '$recordId'})
        prueba({error, data}){
            if(data){
                console.log('resultado-->'+data.tipoCertificacion);
                this.tipocer = data.tipoCertificacion;
                console.log("ese" + data.tipoCertificacion);
                this.certif = data.certificacion;
                console.log(data.certificacion);
            }else if(error){
                console.log(error);
            }
        }
    
        handleSuccess(event) {
            this.recordId = event.detail.id;
            console.log('Record ID: ' + this.recordId);
            const evt = new ShowToastEvent({
                title: 'Certificación registrada',
                message: 'se ha registrado la certificación',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            this.modalIntento = false;
            this.modalTabla = true
            this.generarSecciones();
        
        }

        handleSelection(event) {
            const selectedValue = event.target.value;
            this.valorSeleccionado = selectedValue;
            console.log(selectedValue);
        }

        generarSecciones(){
            console.log(this.valorSeleccionado);
            secciones({certificado: this.valorSeleccionado})
            .then((result) => {
                this.data = result;
                console.log(result);
                console.log(result.data);
            }).catch((errores) => {
                console.log('error:');
                console.log(errores);
            });
        }

        handleSave(event){
            this.fldsItemValues = event.detail.draftValues;
            console.log(this.fldsItemValues);
            savesec({seccionesComp: this.data, idCertiNueva: this.recordId})
            .then((result) => {
                
            }).catch((errores) => {
                
            });
        }   
}