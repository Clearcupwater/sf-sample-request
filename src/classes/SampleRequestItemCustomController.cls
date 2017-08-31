public class SampleRequestItemCustomController {
    public ApexPages.StandardController controller;
    public Sample_Request_Item__c sampleRequestItem {get; set;}
    public boolean renderApprovalButton {get; set;}
    public boolean renderRejectButton {get; set;}
    public boolean renderResubmitButton {get; set;}
	public boolean printerFriendly {get; set;}
	
	public Attachment attachment { 
		get {
		if (attachment == null){
			attachment = new Attachment();
		}
			return attachment;
					
		} set;
	}
	
	
    public SampleRequestItemCustomController(ApexPages.StandardController stdController){
        //field must be on the VFP page for it to work.
		this.controller = stdController;
        this.sampleRequestItem = (Sample_Request_Item__c) stdController.getRecord();
   
    }
    
    public void runOnPageLoad(){
        messageCheck();
        system.debug(printerFriendly);
        setDefaults();
        checkButtons();
    }
    
    public void checkButtons(){
        if (sampleRequestItem.Id != null){
            Sample_Request_Item_Approval__c[] currentApprovals = [Select Id, Status__c, Approval_Order__c, User__c From Sample_Request_Item_Approval__c Where Sample_Request_Item__c =:sampleRequestItem.id Order By Approval_Order__c ASC ]; 
            //show reject button
            if (sampleRequestItem.Stage__c != 'Rejected'){
            	this.renderRejectButton = true; 
            }	
            //check Resubmit button
            if (sampleRequestItem.Stage__c == 'Rejected'){
            	this.renderResubmitButton = true;    
                
            }
            
             
            for(Sample_Request_Item_Approval__c approver: currentApprovals){
                //check Pending
                if(sampleRequestItem.Stage__c =='Pending Approval'){
                If(approver.User__c == UserInfo.getUserID() && approver.Status__c=='Pending'){
                    this.renderApprovalButton = true;
                    break;
                }
                }
            }
		}
    }
    
    public void messageCheck(){
       //get Id from parameters
       //system.debug(ApexPages.currentPage().getParameters().get('Sr'));
        if(sampleRequestItem.Sample_Request__c== null){
       		id Sr = ApexPages.currentPage().getParameters().get('Sr');
       		sampleRequestItem.Sample_Request__c = Sr;
        }
        if(sampleRequestItem.Sample_Request_Item_Type__c == null){
       		String type = ApexPages.currentPage().getParameters().get('type');
 			sampleRequestItem.Sample_Request_Item_Type__c = type;
        }
        
        String error = ApexPages.currentPage().getParameters().get('error');
        
        if(error != null){
          ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info, error));
        
        }
        
        String pfStatus = ApexPages.currentPage().getParameters().get('PF');
        
        if(pfStatus == '1'){
        	this.printerFriendly = true; 
        } else {
        	this.printerFriendly = false;
        }

    }
    
    public void setDefaults(){
        if(sampleRequestItem.Sample_Request__c != null){
        Sample_Request__c sr = [Select Id, Owner__c, Primary_Contact__c, Primary_Contact_First_Name__c, Primary_Contact_Last_Name__c, Primary_Contact_Email__c, Primary_Contact_Phone_Number__c,  Account__c, Shipping_City__c, Shipping_Country__c, Shipping_State_Province__c, Shipping_Street__c, Shipping_Zip_Postal_Code__c, Stage__c From Sample_Request__c Where id = : sampleRequestItem.Sample_Request__c];
        sampleRequestItem.Shipping_Account__c= sr.Account__c;
        sampleRequestItem.Shipping_City__c= sr.Shipping_City__c;
        sampleRequestItem.Shipping_Country__c= sr.Shipping_Country__c;
        sampleRequestItem.Shipping_Street__c= sr.Shipping_Street__c;
        sampleRequestItem.Shipping_Zip_Postal_Code__c= sr.Shipping_Zip_Postal_Code__c;
        sampleRequestItem.Shipping_State_Province__c = sr.Shipping_State_Province__c;
        sampleRequestItem.Owner__c = sr.Owner__c;
        If(sr.Primary_Contact__c != null){
      		
            sampleRequestItem.Primary_Contact__c = sr.Primary_Contact__c;
            sampleRequestItem.Primary_Contact_First_Name__c = sr.Primary_Contact_First_Name__c;
            sampleRequestItem.Primary_Contact_Last_Name__c = sr.Primary_Contact_Last_Name__c;
            sampleRequestItem.Primary_Contact_Email__c = sr.Primary_Contact_Email__c;
            sampleRequestItem.Primary_Contact_Phone_Number__c = sr.Primary_Contact_Phone_Number__c;
        }
     }
        
    }
    
    public Pagereference reset(){
        PageReference resetpg = new PageReference ('/apex/SampleRequestItemPageEdit?=');
        resetpg.getParameters().put('sr', sampleRequestItem.Sample_request__c);
        resetpg.getParameters().put('type',sampleRequestItem.Sample_Request_Item_Type__c);
        resetpg.setRedirect(true);
        return resetpg;
        
    }
        
    
    
    public Pagereference approve(){
    	system.debug('Approval Controller SampleRequestItemCustomController'); 
        
        if (sampleRequestItem.Id != null){
        	
        	//get the Sample Approvals
            Sample_Request_Item_Approval__c indivApproval = [Select Id, Status__c, Approval_Order__c, User__c From Sample_Request_Item_Approval__c Where Sample_Request_Item__c =:sampleRequestItem.id And User__c =:UserInfo.getUserID()];
			system.debug(indivApproval.id);
            system.debug('updating Item Approval');
            //create updateApproval item
            Sample_Request_Item_Approval__c updateApproval = new Sample_Request_item_Approval__c(id = indivApproval.id,Status__c= 'Approved', Date_Approved__c = System.today());
       		
 			update updateApproval;         	
          	system.debug(updateApproval);
          	system.debug('completed approval on controller');
          	

      		    	
			
     	//controller.save();
		
           
           // First fetch  all the approvals attached to the Sample Request Item Approval then work on the next approval record...
		Sample_Request_Item_Approval__c[] currentApprovals = [Select Id, Status__c, Approval_Order__c, User__c From Sample_Request_Item_Approval__c Where Sample_Request_Item__c =:sampleRequestItem.id Order By Approval_Order__c ASC ]; 
            for(Sample_Request_Item_Approval__c approver: currentApprovals){
                system.debug(approver.Status__c);
                If(approver.Status__c == 'Pending'){
                    List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					
					User userInfoRvp = null;
					If(approver.id != null){
                    userInfoRvp = [Select Id, Email, FirstName, LastName From User Where Id=:approver.User__c];
						}
                    
        		
                    User userInfo = [Select Id, Email, FirstName, LastName From User Where Id=:sampleRequestItem.Owner__c]; 
                    List <String> toEmail = new List<String>();
                    List <String> fromEmail = new List<String>();
					toEmail.add(userInfoRvp.email);
                    fromEmail.add(userInfo.email);
                    mail.setToAddresses(toEmail);
                    mail.setCCAddresses(fromEmail);
                    mail.setReplyTo(UserInfo.Email);
                    mail.setSenderDisplayName(UserInfo.FirstName + ' ' + UserInfo.LastName);
                    mail.setSubject('The Following Sample Request is Pending Your Approval');
                    String link = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ SampleRequestItem.Id;
                    mail.setHtmlBody('Please visit the following link to approve the following sample Request. No work begins until the following is approved ' + link);
                    mails.add(mail);
                    Messaging.sendEmail(mails);
                    
                    Sample_Request_Item_Approval__c updateNextApprovalEmail = new Sample_Request_Item_Approval__c(id = approver.id, Emailed__c = true );
                    system.debug('updating the emailed approval'); 
                    update updateNextApprovalEmail;
                    
                    //mark the item as emailed
                    
                }
                Else {
                    
                    
                }
                
                
            }    
           system.debug('Finish Approval Procedures'); 
           
        }
        else return null;
        
	        // send the person to the right page
          	system.debug(sampleRequestItem.id);
          	PageReference returnToView= new PageReference ('/apex/SampleRequestItemPageEdit?id='+sampleRequestItem.id);
          	returnToView.setRedirect(true);
        	return returnToView;        	
        
        
        
    }
    
    public PageReference reject(){
		system.debug(sampleRequestItem.Stage__c);
        PageReference p = Page.SampleRequestItemCommentPageEdit;
        p.setRedirect(true);
        p.getParameters().put('sriId',sampleRequestItem.id);
        p.getParameters().put('cs','2');
		return p;
    	}
    
    
        
    public PageReference newComment(){
    	PageReference p = Page.SampleRequestItemCommentPageEdit;
        p.setRedirect(true);
        p.getParameters().put('sriId',sampleRequestItem.id);
        p.getParameters().put('cs','3');
    	return p;
    }
    
   
	public PageReference resubmit(){
        Sample_Request_Item__c SRI = new Sample_Request_Item__c(id = sampleRequestItem.Id, Stage__c = 'Pending Approval' );
        update SRI;
        PageReference p = new PageReference (URL.getSalesforceBaseUrl().toExternalForm()+'/'+ SampleRequestItem.Id);
        p.setRedirect(true);
        system.debug('Resubmit Procedures no emails fired');
        return p;      
        
        }

    
    public PageReference save(){
    	system.debug('saving');
    	String error = checkRequiredFields();
    	system.debug(error);
    	
    	PageReference p;
    	if(error == null){
    		p = controller.save();
    		
    		
    		
    	} else {
    		p = ApexPages.currentPage();
    		p.setRedirect(false);
        	p.getParameters().put('error',error);
    		
    	}
    	
		return p; 
    }
    
    public String checkRequiredFields() {
    	String checkResults;
		
    	if(SampleRequestItem.Needed_By__c < Date.today())
    		{checkResults = 'Needed By * must be greater than now. Please review and save again.';}
        else if (SampleRequestItem.Needed_By__c == null)
        	{checkResults = 'Needed By * is required. Please review and save again.';}
    	else if(SampleRequestItem.Owner__c == null)
    	 	{checkResults ='Owner * is required. Please review and save again.';}
    	 	
    	     	//checks against shipping address
    	else if(sampleRequestItem.Shipping_Street__c == null)
    			{checkResults='You must enter All Shipping Information. Use Shipping account lookup to simplify input';}
		else if(sampleRequestItem.Shipping_City__c==null)
			{checkResults='You must enter All Shipping Information. Use Shipping account lookup to simplify input' ;}
		else if(sampleRequestItem.Shipping_City__c==null)
			{checkResults='You must enter All Shipping Information. Use Shipping account lookup to simplify input';}
		else if(sampleRequestItem.Shipping_State_Province__c == null)
			{checkResults='You must enter All Shipping Information. Use Shipping account lookup to simplify input';}
		else if(sampleRequestItem.Shipping_Zip_Postal_Code__c ==null)
			{checkResults='You must enter All Shipping Information. Use Shipping account lookup to simplify input';}
		else if(sampleRequestItem.Shipping_Country__c ==null)
			{checkResults='You must enter All Shipping Information. Use Shipping account lookup to simplify input';}
    	else{
    	 	system.debug(checkResults);
    		checkResults = null;}
    		

    		
    	// checks regarding Sample Info assign required fields after analysis
    	
    	
    		
    		
    	
    	
    	return checkResults;
    		
    	
    }
    
    
    public void getNewAddress(){
    	if(sampleRequestItem.Shipping_Account__c == null){
    	sampleRequestItem.Shipping_Street__c = '';
    	sampleRequestItem.Shipping_City__c = '';
    	sampleRequestItem.Shipping_State_Province__c = '';
    	sampleRequestItem.Shipping_Zip_Postal_Code__c= '';
    	sampleRequestItem.Shipping_Country__c= '';
    	
    	
    	} else{
    		    	
    	Account accountInfo = [Select ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry From Account where id =: sampleRequestItem.Shipping_Account__c];
    	sampleRequestItem.Shipping_Street__c = accountInfo.ShippingStreet;
    	sampleRequestItem.Shipping_City__c = accountINfo.ShippingCity;
    	sampleRequestItem.Shipping_State_Province__c = accountInfo.ShippingState;
    	sampleRequestItem.Shipping_Zip_Postal_Code__c= accountInfo.ShippingPostalCode;
    	sampleRequestItem.Shipping_Country__c= accountInfo.ShippingCountry;
    		
    	}
    	

    }
    
    public void getNewContact(){
    	 if(sampleRequestItem.Primary_Contact__c == null){
    	sampleRequestItem.Primary_Contact_First_Name__c = '';
    	sampleRequestItem.Primary_Contact_Last_Name__c = '';
    	sampleRequestItem.Primary_Contact_Email__c = '';
    	sampleRequestItem.Primary_Contact_Phone_number__c = '';
    	
    	} else{
    		    	
    	Contact cont = [Select ID, FirstName, LastName, Email, MobilePhone From Contact Where id =:  sampleRequestItem.Primary_Contact__c];
    	sampleRequestItem.Primary_Contact_First_Name__c = cont.FirstName;
    	sampleRequestItem.Primary_Contact_Last_Name__c = cont.LastName;
    	sampleRequestItem.Primary_Contact_Email__c = cont.Email;
    	sampleRequestItem.Primary_Contact_Phone_number__c = cont.MobilePhone;   		
    	}
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    }
    
    public PageReference directToPrinterFriendly(){
    	    PageReference p = ApexPages.currentPage();
    		p.setRedirect(true);
        	p.getParameters().put('PF','1');
        	p.getParameters().put('id',sampleRequestItem.id);
    		return p; 
    }
    
    public PageReference returnToRegularPage(){
    		PageReference p = ApexPages.currentPage();
    		p.setRedirect(true);
    		p.getParameters().put('PF','2');
    		p.getParameters().put('id',sampleRequestItem.id);
    		return p;
    	}
    	
    public PageReference upload(){
    	attachment.OwnerId = sampleRequestItem.Owner__c;
    	attachment.ParentId = sampleRequestItem.Id;
    	attachment.IsPrivate = false;
    	
    	try {
    		insert attachment;
    	} catch (DMLException e){
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
    		return null;
    	} finally {
    		attachment = new Attachment();
    	}
    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    	return null;

    }
    	
    
        
    

    
    
}