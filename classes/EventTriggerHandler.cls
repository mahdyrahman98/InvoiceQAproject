public with sharing class EventTriggerHandler {
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
}
