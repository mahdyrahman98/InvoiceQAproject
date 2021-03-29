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

}
