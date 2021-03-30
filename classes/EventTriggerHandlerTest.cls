@isTest
public with sharing class EventTriggerHandlerTest {

        @testSetup
        private static void testSetupObjectDataFactory() {
    
            List<Opportunity> oppList = new List<Opportunity>();
            for(Integer i =0; i < 201; i++){
                Opportunity testCourse = new Opportunity (StageName='Scheduled',Name='Testing', Location__c = 'London', Start_Date__c =Date.today(),
                                                        CloseDate= Date.today().addDays(5),
                                                        Course__c='a064L000000SUUFQA4',Instructor__c='0054L000000mM6bQAE') ;
                oppList.add(testCourse);
                
            }
    
            insert oppList;
    
            List<Auto_Number__c> autoNumberList = new List<Auto_Number__c>();
            Auto_Number__c autoNumService = new Auto_Number__c (Name = 'Service Invoice Number', Service_Invoice_Index__c = 1);
            autoNumberList.add( autoNumService);
            Auto_Number__c autoNumExpense = new Auto_Number__c (Name = 'Expense Invoice Number', Service_Invoice_Index__c = 1);
            autoNumberList.add( autoNumExpense);
            insert autoNumberList;
    
            
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = [SELECT Id FROM User WHERE profileId = :p.Id LIMIT 1];
            System.runAs(u){
            }
    
    
        }
        
        @isTest
        public static void OppToEventUpdateOrDelete_Test() {
    
            
    
            Test.startTest();
                    List<Opportunity> oppList = [SELECT Id, StageName,Name,Start_Date__c,CloseDate, OwnerId,Course__c,Instructor__c FROM Opportunity ];
                    System.debug('oppList bring in ' + oppList);
                for(Integer i = 0; i < oppList.size(); i++){
    
                    oppList[i].Start_Date__c = Date.today().addDays(3);
                    
                }
                System.debug('The number'+oppList.size());
                update oppList;   
            Test.stopTest();
            System.assertEquals(201, [SELECT count() FROM Event ]);
    
        }

    }