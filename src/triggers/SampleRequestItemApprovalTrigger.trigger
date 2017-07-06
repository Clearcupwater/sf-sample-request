trigger SampleRequestItemApprovalTrigger on Sample_Request_Item_Approval__c (after insert, after update, before insert, before update) {
 
 	if(Trigger.isAfter){
 		system.debug('After SampleRequestItemApprovalTrigger');
 		
 		Sample_Request_Item_Approval__c Sria = [Select id, Sample_Request_Item__c From Sample_Request_Item_Approval__c where id in: Trigger.newmap.keySet() Limit 1];
 		Sample_Request_Item_Approval__c[] Srias = [Select id, Status__c From Sample_Request_Item_Approval__c where Sample_Request_Item__c =: Sria.Sample_Request_Item__c Order By Approval_Order__c ASC ];
 		
 		integer notApprovedRecords = 0;
 		
 		for(Sample_Request_Item_Approval__c SriaCheck: Srias ){
 			if(SriaCheck.Status__c == 'Pending'){
 				notApprovedRecords = notApprovedRecords + 1;	
 			
 		}
 		}
 		System.debug(notApprovedRecords);	
 		if(notApprovedRecords == 0){
			 Sample_Request_Item__c sri = [Select id, Stage__c, Owner__c From Sample_Request_Item__c where id =: Sria.Sample_Request_Item__c]; 
 			 sri.Stage__c = 'Approved';
 			 system.debug(sri);
 			 update sri;
 			 
 			 // on approval complete the cycle and let the person know it has been approved
 			 User DirectOwner = [Select email From User where id=: sri.owner__c];
 			 string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+Sri.id;
 			 
 			 		Messaging.SingleEmailMessage approvedSampleRequestItem = new Messaging.SingleEmailMessage();
              		List <String> approvedSampleRequestItemTo = new List <String>();
              		list <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    approvedSampleRequestItemTo.add(DirectOwner.Email);
                    approvedSampleRequestItem.setToAddresses(approvedSampleRequestItemTo);
                    approvedSampleRequestItem.setReplyTo('Do_Not_Reply@bentleymills.com');
                    approvedSampleRequestItem.setSenderDisplayName('Bentley Custom Samples Tracking - Do Not Reply');
                    approvedSampleRequestItem.setSubject('Your Existing Inventory/Product Required Samples have been approved');
                    approvedSampleRequestItem.setHtmlBody('Please visit the following link to view your progress ' + Url);
                    mails.add(approvedSampleRequestItem);
                    Messaging.sendEmail(mails);
 			 
 			 
 			 
 			 
 			 
 			 
 			 
 			 
 			 
 		} else {
 			system.debug('did Nothing on SRIT');
 			
 		}
 		
 		
 
 
 
 
 
    
}


}