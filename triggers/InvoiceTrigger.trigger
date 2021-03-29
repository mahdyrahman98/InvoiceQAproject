trigger InvoiceTrigger on Invoice__c (after insert, after update, after delete, before insert, before update, before delete) {
    if(trigger.isBefore){
    
       
    if(trigger.isInsert){
        AutoInvoiceTriggerHandler.generateInv(trigger.new);
    
    }
    else if(trigger.isUpdate){
       
        }
    
    }
     else if(trigger.isDelete){
    
    }
    
    
    
    if(trigger.isAfter) {
        if(trigger.isInsert){
            
           
            
            
         
        }
        else if(trigger.isUpdate) {
 
        }
        else if(trigger.isDelete){
          
           
        }
    
    
    }
    
    }