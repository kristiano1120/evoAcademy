@restResource(urlMapping = '/Campaign/*')
global with sharing class CampaignRest {
    @httpGet
    global static campaignWrapper getCampaign(){
        campaignWrapper respuesta;

        String nombre;

        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        nombre = request.params.get('nombre');

        respuesta = new campaignWrapper(new List<Campaign>(),'Respuesta exitosa', true);
        respuesta.Campaign = [SELECT Id, Name
                                FROM Campaign
                                WHERE Name = : nombre];

        return respuesta;        
    }

    global class campaignWrapper{
        global List<Campaign> campaign;
        global String mensaje;
        global Boolean resultado;
        
        global campaignWrapper(List<Campaign> campaign, String mensaje, Boolean resultado) {
            this.campaign = campaign;
            this.mensaje = mensaje;
            this.resultado = resultado;             
        }
    }
}
