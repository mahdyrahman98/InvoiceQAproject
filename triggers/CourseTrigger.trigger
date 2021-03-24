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
        CourseTriggerHandler.shareEvent(trigger.new, trigger.old, trigger.oldMap);
        CourseTriggerHandler.sendEmail(trigger.new);
     
    }
    else if(trigger.isUpdate) {
        CourseTriggerHandler.shareEvent(trigger.new, trigger.old, trigger.oldMap);
        CourseTriggerHandler.sendEmail(trigger.new);
    }
    else if(trigger.isDelete){
        courseTriggerHandler.shareEvent(trigger.new, trigger.old, trigger.oldMap);
       
    }


}

}