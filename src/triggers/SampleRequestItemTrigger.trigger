trigger SampleRequestItemTrigger on Sample_Request_Item__c (before insert, before update, after insert, after update) {

//trigger before insert
if(Trigger.isBefore){
	system.debug('Is Before Trigger SampleRequestItemTrigger ');
    if(Trigger.isInsert == true){
        for(Sample_Request_Item__c srin: Trigger.new){
            if(srin.Sample_Request_Item_Type__c=='Custom Sample'){
                    srin.Stage__c = 'Approved';
                    

                    }
            if(srin.Sample_Request_Item_Type__c=='Custom Simulation'){
                srin.Stage__c = 'Approved';
                


            		}
            
            
            if(srin.Sample_Request_Item_Type__c=='Running Line Product Mockup'){
                srin.Stage__c = 'Pending Approval';
                
            }
            
            if(srin.Sample_Request_Item_Type__c=='Custom/Custom Color PDS Production Trial'){
                srin.Stage__c = 'Pending Approval';
                
            }
            
            
        }
        
    }
}
 
 
 
 
 
 
    
    if(Trigger.isAfter){
    	system.debug('In is After trigger SampleRequestItemTrigger');
		
		//get some overall data
		Sample_Request_Item_Approval__c[] Sras = [Select id, Sample_Request_Item__c From Sample_Request_Item_Approval__c where Sample_Request_Item__c =:Trigger.newmap.keySet()];
        Sample_Request_Item__c Sri = [Select id, Stage__c, Sample_Request_Item_Type__c,Owner__c From Sample_Request_Item__c where id =:Trigger.newmap.keySet()];
		User DirectOwner = [Select Email From User where id = : Sri.Owner__c];
		list <Messaging.SingleEmailMessage> quickApprovals = new List<Messaging.SingleEmailMessage>();
		string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+Sri.id;
		//if either Custom Sample or Custom Simulation
		
		if(sri.Sample_Request_Item_Type__c == 'Custom Sample' && trigger.isInsert){					
					List <String> Tos = new List <String>();
					List <String> CCs = new List <String>();
					CCs.add(DirectOwner.Email);
					Tos.add('crm@bentleymills.com');
					String Subject = 'Your Custom Sample has been automatically approved';
					String Body = UtilityBentley.provideSampleRequestHeader(Sri.id);
					String Lines = UtilityBentley.provideLineItems(Sri.id);
                    UtilityBentley.SendEmail(Subject,Tos, CCs, Body+Lines);
                    					
				}
		
		if(sri.Sample_Request_Item_Type__c=='Custom Simulation'&& trigger.isInsert){
					List <String> Tos = new List <String>();
					List <String> CCs = new List <String>();
					CCs.add(DirectOwner.Email);
					Tos.add('crm@bentleymills.com');
					String Subject = 'Your Custom Simulation has been automatically approved';
					String Body = UtilityBentley.provideSampleRequestHeader(Sri.id);
					String Lines = UtilityBentley.provideLineItems(Sri.id);
                    UtilityBentley.SendEmail(Subject,Tos, CCs, Body+Lines);
			
		}
		
		
		//checks to see if the item is approved. If approved, skpps the rest of the code
		boolean turnOn; 
		for (Sample_Request_Item__c check: Trigger.new){
				if(check.Stage__c == 'Approved'){
					turnOn = false;
				} else
					turnOn = true;
			
		}
		//begining of code
		if(turnOn == true){
        	if (Sras.isEmpty()){
			
				}else {
			if(Sri.Stage__c =='Pending Approval'){
				system.debug('delete related records'); 
				try{
        			delete Sras;
        			}
    			catch(DmlException e){
    			system.debug(e);
    			
    			}		
			}			
        }
		
        
    
    	
    	if(Sri.Stage__c =='Pending Approval') {
    	//get rvp data
       	Sample_Request_Item__c[] RVP = [Select Owner__c, Owner__r.RVP__c From Sample_Request_Item__c Where Id in:Trigger.newmap.keySet()];
        List <id> RvpList = new List<Id>();
        system.debug(RVP);
        for (Sample_Request_Item__c r : RVP){
            RvpList.add(r.Owner__r.RVP__c);
        }
        User[] RvpInfo = [Select Id,FirstName, LastName, Email From User Where Id in:RvpList];
        
        list <Sample_Request_Item_Approval__c> insertRecords = new List<Sample_Request_Item_Approval__c>();
        list <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        
        //do special processing for special items
        for(Sample_Request_Item__c srin: Trigger.new){
            
            for(User r : RvpInfo){
            if(srin.Sample_Request_Item_Type__c=='Running Line Product Mockup'){
                Sample_Request_Item_Approval__c sria = new Sample_Request_Item_Approval__c(Approval_Order__c = 1, Sample_Request_Item__c = srin.id, Status__c = 'Pending', User__c = r.id); 
            	insertRecords.add(sria);
            	//
            }
             if(srin.Sample_Request_Item_Type__c=='Custom/Custom Color PDS Production Trial'){
         		Sample_Request_Item_Approval__c sria = new Sample_Request_Item_Approval__c(Approval_Order__c = 1, Sample_Request_Item__c = srin.id, Status__c = 'Pending', User__c = r.id);
    				insertRecords.add(sria);
                Sample_Request_Item_Approval__c sria2 = new Sample_Request_Item_Approval__c(Approval_Order__c = 2, Sample_Request_Item__c = srin.id, Status__c = 'Pending', User__c ='005j000000AxNwV' );
                	insertRecords.add(sria2);
                
                
        		}
            	system.debug(insertRecords);
            insert insertRecords;
       		
       	Sample_Request_Item_Approval__c [] currentApprovals = [Select Id, Status__c, Approval_Order__c, User__c, Sample_Request_Item__r.Owner__r.RVP__c, Sample_Request_Item__r.Owner__c From Sample_Request_Item_Approval__c where Sample_Request_Item__c in: Trigger.newmap.keySet() Order By Approval_Order__c ASC ];
        	 for(Sample_Request_Item_Approval__c approver: currentApprovals){
             
             //send Emails to proper person email one. Kicks off then the controller triggers the rest... 
             If(approver.Status__c == 'Pending'){
                 system.debug('Trigger for Email Moving into Pending');
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    User userInfoRvp = [Select Id, Email, FirstName, LastName From User Where Id=:approver.Sample_Request_Item__r.Owner__r.RVP__c];
                    User userInfo = [Select Id, Email, FirstName, LastName From User Where Id=:approver.Sample_Request_Item__r.Owner__c]; 
                    List <String> toEmail = new List<String>();
                    
                    List <String> fromEmail = new List<String>();
					system.debug('Where the request is comming from');
					system.debug(userInfo.email);
					toEmail.add(userInfoRvp.email);
                    fromEmail.add(userInfo.email);
                    mail.setToAddresses(toEmail);
                    mail.setSubject('The Following Sample Request is Pending Your Approval');
                    String Body = UtilityBentley.provideSampleRequestHeader(Sri.id);
					String Lines = UtilityBentley.provideLineItems(Sri.id);
                    
                    
                    
                    
                    
                    mail.setHtmlBody('Please visit the following link to approve the following sample Request. No work begins until the following is approved '+ Url +  '<br>' + Body + Lines);
                    
                    mails.add(mail);
              //send Email to Owner of Sample Request Letting them know that the record has been submitted
              		Messaging.SingleEmailMessage confirmation = new Messaging.SingleEmailMessage();
              		List <String> confirmationTo = new List <String>();
                    confirmationTo.add(userInfo.email);
                    confirmation.setToAddresses(confirmationTo);
                    confirmation.setReplyTo('Do_Not_Reply@bentleymills.com');
                    confirmation.setSubject('Bentley Custom Samples Tracking - Do Not Reply');
                    confirmation.setHtmlBody('Existing Inventory Samples must be approved by your RVP. Production Required Samples must be approved by your RVP and confirmed with the Mill. Please visit the following link to view your progress ' + Url + '<br>' + Body + Lines);
                    mails.add(confirmation);
                    
                    Messaging.sendEmail(mails);
                 system.debug('Complete Email for Pending ');
                 // update Approval 
                Sample_Request_Item_Approval__c updateApproval = new Sample_Request_Item_Approval__c(id = approver.id, Emailed__c = true, Date_Emailed__c = System.Today());
                	update updateApproval;
            	     
                 break;
                }
                Else {
                     
                    
						}
					}
				}
			}
		}
		}
    }
    
    	
	 
                                  

    
    
    
    
    
    
    
    

}