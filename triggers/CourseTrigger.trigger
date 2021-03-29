trigger CourseTrigger on Opportunity (after insert, after update) {
    if(trigger.isBefore){
    
       
    if(trigger.isInsert){
    
    }
    else if(trigger.isUpdate){
       
        }
    
    }
     else if(trigger.isDelete){
    
    }
    
    
    
    if(trigger.isAfter) {
        if(trigger.isInsert){
            CourseTriggerHandler.shareCourse(trigger.new);
            EventTriggerHandler.shareEvent(trigger.new, trigger.old, trigger.oldMap);
            EmailTriggerHandler.sendEmail(trigger.new);
            EmailTriggerHandler.createServiceInvoice(trigger.new);
            
            
         
        }
        else if(trigger.isUpdate) {
            EventTriggerHandler.shareEvent(trigger.new, trigger.old, trigger.oldMap);
            EmailTriggerHandler.sendEmail(trigger.new);
        }
        else if(trigger.isDelete){
            EventTriggerHandler.shareEvent(trigger.new, trigger.old, trigger.oldMap);
           
        }
    
    
    }
    
    }