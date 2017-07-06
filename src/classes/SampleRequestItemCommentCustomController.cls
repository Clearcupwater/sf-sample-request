public class SampleRequestItemCommentCustomController {
    public ApexPages.StandardController controller;
    public Sample_Request_Item_Comment__c sampleRequestItemComment {get; set;}
    public Sample_Request_Item_Comment__c[] sampleRequestItemComments {get; set;}
    public Sample_Request_Item__c sampleRequestItem {get; set;}
	public Boolean changeToNeedsAdditionalInfo {get; set;}
	public Boolean changeToRejected {get; set;}
	public Boolean changeToAddNewComment {get; set;}
	public Boolean changeToCompleted {get; set;}
	public String Instructions {get; set;}
    
    public SampleRequestItemCommentCustomController(ApexPages.StandardController stdController){
        //field must be on the VFP page for it to work.
		this.controller = stdController;
        this.sampleRequestItemComment = (Sample_Request_Item_Comment__c) stdController.getRecord();
   
    }

    public void runOnPageLoad(){
		messageCheck();
    }
    
    
    public void messageCheck(){
    	id SriId = ApexPages.currentPage().getParameters().get('sriId');
    	
    	if (SriId != null){
    		
        this.sampleRequestItem = [Select Stage__c, Owner__c, Sample_Request__c From Sample_Request_Item__c where id =: SriId];
        this.sampleRequestItemComments = [Select Comment__c, Sample_Request_Item__c, LastModifiedDate From Sample_Request_Item_Comment__c where Sample_Request_Item__c =: sampleRequestItem.id];
    	sampleRequestItemComment.Sample_Request_Item__c = sampleRequestItem.id;
    	system.debug('value of sampleRequestItem');
    	system.debug(sampleRequestItemComment.Sample_Request_Item__c);
    	
    	if(ApexPages.currentPage().getParameters().get('cs')=='1'){
    		changeToNeedsAdditionalInfo = true;
    		sampleRequestItemComment.Comment_Reason__c = 'Needing Additional Information';
    		Instructions ='Add a comment why you need more info';
    	}
    	
    	if(ApexPages.currentPage().getParameters().get('cs')=='2')
    	{
    		changeToRejected = true;
    		sampleRequestItemComment.Comment_Reason__c = 'Rejected';
    		Instructions ='Add a comment Why you rejected this request'; 
    	}
    	
    	if(ApexPages.currentPage().getParameters().get('cs')=='3')
    	{
    		changeToAddNewComment = true;
    		sampleRequestItemComment.Comment_Reason__c = 'Added Extra Info';
    		Instructions ='Add Comments'; 
    	}
    	
    	
    	
    	
    	if(ApexPages.currentPage().getParameters().get('cs')=='4'){
    		changeToCompleted = true;
    		sampleRequestItemComment.Comment_Reason__c = 'Completed';
    		Instructions ='Add a comment to close the request. Cannot be Blank'; 
    	}
    	
    	
    	}
    	
    }
    
   public PageReference save(){
   		//check if we need to change the status of a awaiting more information to Waiting Approval	
   		controller.save();
   		
   		
   		
   		if (changeToNeedsAdditionalInfo!=null) {
	   			 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        	List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
	       	    List <String> toEmail = new List<String>();
	        	User userInfo = [Select Id, Email, FirstName, LastName From User Where Id=:sampleRequestItem.Owner__c];
	        	toEmail.add(userInfo.Email);
	      		mail.setToAddresses(toEmail);
		        mail.setReplyTo('Do_Not_Reply@bentleymills.com');
		        mail.setSenderDisplayName('Bentley Custom Samples Tracking - Do Not Reply');
		        mail.setSubject('The following Sample Needs additional Information To Continue ' + SampleRequestItem.Id);
		       	String link = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ SampleRequestItem.Id;
		       	mail.setHtmlBody('Please visit the following link to see the Sample Comments. Select Provide additional Comments to add information.' + link);
		        mails.add(mail);
		        Messaging.sendEmail(mails);	
				Sample_Request_Item__c SRI = new Sample_Request_Item__c(id = sampleRequestItem.Id, Stage__c = 'Needing Additional Information' );
		        update SRI;	} 
	        
	        else if (changeToRejected!=null) {
	   			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        	List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
	       	    List <String> toEmail = new List<String>();
	        	User userInfo = [Select Id, Email, FirstName, LastName From User Where Id=:sampleRequestItem.Owner__c];
	        	toEmail.add(userInfo.Email);
	      		mail.setToAddresses(toEmail);
		        mail.setReplyTo('Do_Not_Reply@bentleymills.com');
		        mail.setSenderDisplayName('Bentley Custom Samples Tracking - Do Not Reply');
		        mail.setSubject('The following Sample Has been rejected ' + SampleRequestItem.Id);
		       	String link = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ SampleRequestItem.Id;
		       	mail.setHtmlBody('The Following comment was said about your Sample Request Item. '+sampleRequestItemComment.Comment__c+'. Please visit the following link to see the Sample Comment details.' + link);
		        mails.add(mail);
		        Messaging.sendEmail(mails);	
				Sample_Request_Item__c SRI = new Sample_Request_Item__c(id = sampleRequestItem.Id, Stage__c = 'Rejected' );
		        update SRI;
   			
   			} else if(changeToCompleted!= null ){
   				 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		        List <String> toEmail = new List<String>();
		        User userInfo = [Select Id, Email, FirstName, LastName From User Where Id=:sampleRequestItem.Owner__c];
		        toEmail.add(userInfo.Email);
		      	mail.setToAddresses(toEmail);
		        mail.setReplyTo('Do_Not_Reply@bentleymills.com');
		        mail.setSenderDisplayName('Bentley Custom Samples Tracking - Do Not Reply');
		        mail.setSubject('The following sample has been moved to Completed ' +SampleRequestItem.Id);
		       	String link = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ SampleRequestItem.Id;
		       	mail.setHtmlBody('Please visit the following link to see the Sample Request Details ' + link +'If you need a new sample order, please create a new request. If this is the last sample request, the sample request will be closed ');
		        mails.add(mail);
		        Messaging.sendEmail(mails);
				system.debug('process complete');        
				Sample_Request_Item__c SRI = new Sample_Request_Item__c(id = sampleRequestItem.Id, Stage__c = 'Completed' );
		        update SRI;
				system.debug(sampleRequestItem.Stage__c);
		        //check SRI and if all records are completed 0 then close the sample request headr
		        
		        Sample_Request_Item__c[] sris = [Select id, Stage__c, Sample_Request__c From Sample_Request_Item__c where Sample_Request__c =: sampleRequestItem.Sample_Request__c ];
		        integer recordsOpen = 0;
		        for (Sample_Request_Item__c currentSri : sris){
		        	if(currentSri.Stage__c != 'Completed'){
		        		recordsOpen = recordsOpen + 1;
									}
        						}       
					//if all records are completed close the sample request header 
					if (recordsOpen == 0 ){
						Sample_Request__c updateSri = new Sample_Request__c(id = sampleRequestItem.Sample_Request__c, Stage__c ='Closed');
						system.debug(updateSri);
						update updateSri;        
							
						system.debug('Main Header Sample Request has been updated');
						
					}
   			}
   			
   			//if we are needing Additional information and prior stage was Needing Additioanl no email fired just updated as appropriate
   			else if (sampleRequestItem.stage__c == 'Needing Additional Information' ){
   				Sample_Request_Item__c sri = new Sample_Request_Item__c(id=sampleRequestItem.id, stage__c='Work In Progress');
   				update sri;
   				system.debug('sri was updated due to a new comment being added');
   			} 
   		
   		PageReference p = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/'+ sampleRequestItem.Id);
        p.setRedirect(true);
    	return p;
   		}
   
   
   
   
   
    	
   }