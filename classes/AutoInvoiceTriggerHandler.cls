public with sharing class AutoInvoiceTriggerHandler {
    public static void generateInv(List<Invoice__c> invAuto ){
        Auto_Number__c[] Index = [SELECT  Service_Invoice_Index__c, Expense_Invoice_Index__c FROM Auto_Number__c];
        
        List<Auto_Number__c> increment = [SELECT Service_Invoice_Index__c, Expense_Invoice_Index__c FROM Auto_Number__c];
        List<Auto_Number__c> toUpdate = new List<Auto_Number__c>();
        
        String ServiceRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
        String ExpenseRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Expense Invoice').getRecordTypeId();
        
        for (Course_invoices__c a : courseInvoices){
            
            if(a.RecordTypeId == ServiceRecordType){
                
                Decimal toInt = Index[0].Service_Invoice_Index__c.intValue();
                String toString = toInt.toPlainString();
                Integer size = toString.length();            
                Integer addZeros = 4 - size;            
                String placeHolder = '';
                
                for(Integer i = 0; i < addZeros; i++){
                    placeHolder += '0';
                }
                
                a.Name = 'INV-{'+ placeHolder + Index[0].Service_Invoice_Index__c + '}';
                Auto_Number__c test = increment[0];
                test.Service_Invoice_Index__c += 1;
                toUpdate.add(test);
            }
            
            else if(a.RecordTypeId == ExpenseRecordType){
                
                Decimal toInt = Index[0].Expense_Invoice_Index__c.intValue();
                String toString = toInt.toPlainString();
                Integer size = toString.length();            
                Integer addZeros = 4 - size;            
                String placeHolder = '';
                
                for(Integer i = 0; i < addZeros; i++){
                    placeHolder += '0';
                }
                
                a.Name = 'EXPINV-{' + placeHolder + Index[0].Expense_Invoice_Index__c + '}';
                Auto_Number__c test = increment[0];
                test.Expense_Invoice_Index__c += 1;
                toUpdate.add(test);
                
                
            }
        }
        update toUpdate;
    }

    }
        
    
    