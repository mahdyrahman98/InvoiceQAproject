public with sharing class CourseTriggerHandler {

    public static void shareCourse(List<Opportunity> coursesToShare){
        // create list of opportunity share records for later insertion
        List<OpportunityShare> opportunitiesToShare = new List<OpportunityShare>();

        //  for each opportunity in trigger.new 
        for( Opportunity opportunity : coursesToShare) {

        // create opportunity share object
       
        OpportunityShare shareobject = new OpportunityShare();
       
        // set field values on share object
        shareobject.OpportunityID =  opportunity.Id;
        shareobject.OpportunityAccessLevel = 'Edit';
        shareobject.UserOrGroupId = opportunity.Instructor__c;

        // add share object to list
       
        opportunitiesToShare.add(shareobject);       

    }
    // insert list
    insert opportunitiesToShare;
}


public static void shareEvent(List<Opportunity> courses, List<Opportunity> oldCourses, Map<Id,Opportunity> oldMap){
  
    List<Event> Events = new List<Event>();
  

    List<Opportunity> courseInsert = new List<Opportunity>();
    List<Opportunity> courseUpdate = new List<Opportunity>();
    List<Opportunity> courseCancelled = new List<Opportunity>();


    for(Opportunity opportunity : courses){

        if(oldMap==Null||oldMap.get(opportunity.Id)==Null){
            courseInsert.add(opportunity);       
        }
          else if(opportunity!=oldMap.get(opportunity.Id)){
            
           if(opportunity.StageName == 'Cancelled' && oldMap.get(opportunity.Id).StageName!='Cancelled'){
        
                courseCancelled.add(opportunity);
             }
            else if(opportunity.stageName != 'Completed'){

             courseUpdate.add(opportunity);
            
             }
            
          }
         
}
if(courseInsert.size()>0){

    Event calendarEvent = new Event();
    for(Opportunity opportunity : courseInsert){
    calendarEvent.Subject = 'Course';
    calendarEvent.StartDateTime = opportunity.Start_Date__c;
    calendarEvent.EndDateTime = opportunity.CloseDate;
    calendarEvent.OwnerId = opportunity.Instructor__c;
    calendarEvent.Location = opportunity.Location__c;
    calendarEvent.WhatId = opportunity.Id;

  
    Events.add(CalendarEvent);
    }
}
insert Events;

        if(courseCancelled.size()>0){
            Set<Id> courseCancelledIds = new Set<Id>();

            for(Opportunity opportunity : courseCancelled){

                courseCancelledIds.add(opportunity.Id);
                

            }
            List<Event> eventsToDelete = new List<Event>([Select Id FROM Event WHERE WhatId in: courseCancelledIds]);
           System.debug(eventsToDelete.size());
            delete eventsToDelete;
            
        }
        if(courseUpdate.size()>0){
            Map<Id,Event> updatedCourseMap = new Map<Id, Event>();
            Set<Id> oppIdSet = new Set<Id>();
             for(Opportunity opp: courseUpdate){

             oppIdSet.add(opp.Id);
               
        
             }
             List<Event> eventsToUpdate = new List<Event>([SELECT Subject, StartDateTime, EndDateTime, OwnerId, Location, WhatId FROM Event WHERE WhatId in :oppIdSet]);
             for(Event e : eventsToUpdate){
                 updatedCourseMap.put(e.whatId, e);

             }
             for(Opportunity opp : courseUpdate){
                 Event e = updatedCourseMap.get(opp.Id);
                 e.Subject = opp.Name;
                 e.StartDateTime = opp.Start_Date__c;
                 e.EndDateTime = opp.CloseDate;
                 e.OwnerId = opp.Instructor__c;
                 e.Location = opp.Location__c;
                 e.WhatId = opp.Id;

                 updatedCourseMap.put(opp.Id, e);
    

             }
             update updatedCourseMap.values();

            

        }

    }
    
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


//     for(Invoice__c inv : invoicesToInsert)
//         integer duration = inv.Courses__r.duration__c;
//         for(integer i = 0 ; i < duration ; i++){
//             invoice_line_item__c newline = new invoice_line_item__c();
//             newline.recordtypeId = serviceLineRecTypeId;
//             newline.Date__c = inv.courses__r.Start_Date__c.addDays(i);
//             newline.A__c = '50';
//             newline.Invoice__c = inv.Invoice__r.name;
//         }
//    }
//     insert invoiceLinesToInsert;
    
}
}