public class SampleRequestCustomController {
    public ApexPages.StandardController controller;
    public Sample_Request__c sampleRequest {get; set;}
    public id sampleRequestId {get; set;}
    public double opportunityAmountTest {get; set;}  
    
    
    public SampleRequestCustomController(ApexPages.StandardController stdController){
        //field must be on the VFP page for it to work.
		this.controller = stdController;
        this.sampleRequest = (Sample_Request__c) stdController.getRecord();
        
    }
    
    public PageReference runOnPageLoad(){
        messageCheck();
        try {
     	setOpportunityAmountTest();
     	getOpportunityDataNewPage();
     	if (opportunityAmountTest == null) {
        		PageReference p = issueError('Please return to the Opportunity and add opportunity amount on the project');
        		return p;
        	} else {
        		return null; 
        	}
        }
            
        catch (QueryException e){
            PageReference p =issueError('Do not be dumb. Create Data From an Opportunity. - ' + e.getMessage());
            return p;
        }
        catch(Exception e){
            PageReference p = issueError('You got an error ' + e.getMessage());
            return p;
        }
           
    }
    
    public void messageCheck(){
    	String error = ApexPages.currentPage().getParameters().get('error');
        if(error != null){
          ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info, error));
        
        }
    	
    	
    }
    
    
    
    public void getOpportunityDataNewPage(){
        if(sampleRequest.Account__c==null && sampleRequest.Shipping_Street__c==null){
        	Opportunity opp = [Select Id, AccountId, OwnerId, Amount From Opportunity Where id = :samplerequest.Opportunity__c ];
            Account acct = [Select Id, ShippingStreet, ShippingCity,ShippingState, ShippingPostalCode,ShippingCountry From Account Where id =:opp.AccountId];
            //set values
            sampleRequest.Account__c= opp.accountid;
            sampleRequest.Owner__c = opp.ownerid;
            sampleRequest.Shipping_Street__c = acct.ShippingStreet;
            sampleRequest.Shipping_City__c = acct.ShippingCity;
            sampleRequest.Shipping_State_Province__c = acct.ShippingState;
            sampleRequest.Shipping_Zip_Postal_Code__c = acct.ShippingPostalCode;
            sampleRequest.Shipping_Country__c = acct.ShippingCountry;
        } 
      
    }
    
    public void setOpportunityAmountTest() {
    	if (sampleRequest.Opportunity_Amount__c == null){
    			// new
    			system.debug('On new'); 
        		String returnurl = ApexPages.currentPage().getParameters().get('retURL');
    			String oppId = returnurl.right(15);
    			Opportunity opp = [Select Amount from Opportunity where id =:oppId];
    			this.opportunityAmountTest = opp.amount;
        	} else {
        		system.debug('On Old');
        		system.debug(ApexPages.currentPage().getParameters().get('id'));
        		Sample_Request__c sr = [Select Opportunity_Amount__c from Sample_Request__c where id =: ApexPages.currentPage().getParameters().get('id')];
        		this.opportunityAmountTest = sr.Opportunity_Amount__c;
        	}
    	}    	
    
    
    
    //fires when Account record is changed
    public void getOpportunityDataChangeAccount(){
            if(sampleRequest.Account__c == null) {
           	sampleRequest.Shipping_Street__c = '';
            sampleRequest.Shipping_City__c = '';
            sampleRequest.Shipping_State_Province__c = '';
            sampleRequest.Shipping_Zip_Postal_Code__c = '';
            sampleRequest.Shipping_Country__c = '';      
    
            }else {
    		Account acct = [Select Id, ShippingStreet, ShippingCity,ShippingState, ShippingPostalCode,ShippingCountry From Account Where id =:sampleRequest.Account__c];
            sampleRequest.Shipping_Street__c = acct.ShippingStreet;
            sampleRequest.Shipping_City__c = acct.ShippingCity;
            sampleRequest.Shipping_State_Province__c = acct.ShippingState;
            sampleRequest.Shipping_Zip_Postal_Code__c = acct.ShippingPostalCode;
            sampleRequest.Shipping_Country__c = acct.ShippingCountry;          	
            }   
    }
    
   
    
    public void getContactDataChangeContact(){
    		if(sampleRequest.Primary_Contact__c == null){
    		sampleRequest.Primary_Contact_First_Name__c	= '';
    		sampleRequest.Primary_Contact_Last_Name__c = '';
    		sampleRequest.Primary_Contact_Phone_Number__c = '';
    		sampleRequest.Primary_Contact_Email__c = '';	
    		} else {
    		Contact cont = [Select ID, FirstName, LastName, Email, MobilePhone From Contact Where id =: sampleRequest.Primary_Contact__c];
    		//set value
    		sampleRequest.Primary_Contact_First_Name__c	= cont.FirstName;
    		sampleRequest.Primary_Contact_Last_Name__c = cont.LastName;
    		sampleRequest.Primary_Contact_Phone_Number__c = cont.MobilePhone;
    		sampleRequest.Primary_Contact_Email__c = cont.Email;	
    		}
    }

    
    public PageReference newSampleItem() {
        PageReference p = new PageReference('/apex/SampleRequestItemPageEdit');
        p.setRedirect(true);
        p.getParameters().Put('Sr',controller.getId());
        return p;
    }
    
    
    public PageReference issueError(String errorMesssage){
     	PageReference p = new PageReference ('/apex/BentleyCustomErrorPage'); 
        p.getParameters().put('Error', errorMesssage);
        p.setRedirect (true);
        system.debug('Before the return of page reference');
        return p; 
        
    }
    
    public PageReference save(){
    	system.debug('saving');
    	String error = checkRequiredFields();
    	
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
		
    	if(SampleRequest.Owner__c == null)
    		{checkResults = 'Owner * is required. Please review and save again.';}
    	 else if(SampleRequest.Account__c == null)
    	 	{checkResults = 'Requesting account is required. Please review and save again';}
    	 else{
    		checkResults = null;}
    		
    	//checks against shipping address
    	
    	if(sampleRequest.Shipping_Street__c == null)
    			{checkResults='You must enter All Shipping Information. Use Requesting account lookup to simplify input';}
    		else if(sampleRequest.Shipping_City__c==null)
    			{checkResults='You must enter All Shipping Information. Use Requesting account lookup to simplify input' ;}
    		else if(sampleRequest.Shipping_City__c==null)
    			{checkResults='You must enter All Shipping Information. Use Requesting account lookup to simplify input';}
    		else if(sampleRequest.Shipping_State_Province__c == null)
    			{checkResults='You must enter All Shipping Information. Use Requesting account lookup to simplify input';}
    		else if(sampleRequest.Shipping_Zip_Postal_Code__c ==null)
    			{checkResults='You must enter All Shipping Information. Use Requesting account lookup to simplify input';}
    		else if(sampleRequest.Shipping_Country__c ==null)
    			{checkResults='You must enter All Shipping Information. Use Requesting account lookup to simplify input';}
    		else
    		{checkResults = null;}

    	return checkResults;
    		
    	
    }
    
    
    
    
    
    
    
    
    
    

}