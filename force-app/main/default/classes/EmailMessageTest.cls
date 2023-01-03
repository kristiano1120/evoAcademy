@istest
public with sharing class EmailMessageTest {

    @TestSetup
    static void makeData(){
        Lead candidato = new Lead(FirstName = 'Prueba', LastName='1', company = 'E-volution', email = 'kristiano1120@gmail.com');
        Insert candidato;

        //EmailTeplate template = new EmailTeplate();
        //Insert template;

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();


    }
}