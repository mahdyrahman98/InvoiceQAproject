public with sharing class EmailTriggerHandler {
    public static void sendEmail(List<Opportunity> courses){


        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();



          List<Opportunity> listofinstructors = new List<Opportunity>([SELECT Id, Name, Start_Date__C, Instructor__r.email, Instructor__r.name, StageName From Opportunity WHERE id in :courses]);




        for(Opportunity course : listofinstructors){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<String> toAdresses = new List<String>();
            if(course.StageName == 'Cancelled'){
                String body = 'Dear: ' + Course.Instructor__r.name + ', <br> Your course of type: ' + Course.Name + '. Starting on ' + course.Start_Date__c + 'has been cancelled';
                toAdresses.add(Course.Instructor__r.Email);
                email.setToAddresses(toAdresses);
                email.setSubject('Cancelled Course');
                email.setHtmlBody(body);
                emails.add(email);


            }
            else if(course.StageName == 'Scheduled') {


            String body = 'Dear: ' + Course.Instructor__r.name + ', <br> You have a course of type: ' + Course.Name + '. Starting on ' + course.Start_Date__c + '.';
            toAdresses.add(Course.Instructor__r.Email);
            email.setToAddresses(toAdresses);
            email.setSubject('Scheduled');
            email.setHtmlBody(body);
            emails.add(email);
            }
        }
        if(emails.size()>0){
        Messaging.sendEmail(emails, false);
        }
    }
 


    public static void createServiceInvoice(List<Opportunity> serviceInvoices ){

//     //instatiate list of courses
    list<Invoice__c> invoicesToInsert = new List<Invoice__c>(); 
    List<Invoice_Line_Item__c> invoiceLinesToInsert = new List<Invoice_Line_Item__c>();
    Id serviceLineRecTypeId = Schema.SObjectType.Invoice_Line_Item__c.getRecordTypeInfosByName().get('Services').getRecordTypeId();
    Id serviceRecTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
//     // when course status = completed. make an if statement stating StageName = completed
    for(Opportunity course : serviceInvoices){
        if(course.StageName == 'Completed'){
            Invoice__c newInv = new Invoice__c();
            newInv.Status__c= 'Draft';
            newInv.Invoice_Date__c= Date.today();
            newInv.Courses__c= course.Id;
            newInv.RecordTypeId = serviceRecTypeId;

            invoicesToInsert.add(newInv);
        }
    }
    insert invoicesToInsert;

    for(Invoice__c inv : invoicesToInsert){
        decimal duration = inv.Courses__r.duration__c;
        for(integer i = 0 ; i < duration ; i++){
            invoice_line_item__c newline = new invoice_line_item__c();
            newline.recordtypeId = serviceLineRecTypeId;
            newline.Date__c = inv.courses__r.Start_Date__c.addDays(i);
            newline.A__c = 50.00;
            newline.Invoice__c = inv.Id;

            invoiceLinesToInsert.add(newline);
        }
   }
    insert invoiceLinesToInsert;
}
    
}


