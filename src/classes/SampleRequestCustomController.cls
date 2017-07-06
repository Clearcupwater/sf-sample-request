public class SampleRequestCustomController {
    public ApexPages.StandardController controller;
    public Sample_Request__c sampleRequest {get; set;}
    public id sampleRequestId {get; set;}
    
    
    public void SampleRequestCustomController(ApexPages.StandardController stdController){
        //field must be on the VFP page for it to work.
		this.controller = stdController;
        this.sampleRequest = (Sample_Request__c) stdController.getRecord();
        
    }
    
    public PageReference runOnPageLoad(){
        messageCheck();
        try {
     	getOpportunityDataNewPage();
            return null;
            }
        catch (QueryException e){
            PageReference p =issueError('Do not be dumb. Create Data From an Opportunity. - ' + e.getMessage());
            return p;
        }
        catch(Exception e){
            PageReference p = issueError('You got an error ' + e.getMessage());
            return p;
        }
        finally{   
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
			Opportunity opp = [Select Id, AccountId, OwnerId From Opportunity Where id = :samplerequest.Opportunity__c ];
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
    //fires when Account record is changed
    public void getOpportunityDataChangeAccount(){
            Account acct = [Select Id, ShippingStreet, ShippingCity,ShippingState, ShippingPostalCode,ShippingCountry From Account Where id =:sampleRequest.Account__c];
            //set values
            sampleRequest.Shipping_Street__c = acct.ShippingStreet;
            sampleRequest.Shipping_City__c = acct.ShippingCity;
            sampleRequest.Shipping_State_Province__c = acct.ShippingState;
            sampleRequest.Shipping_Zip_Postal_Code__c = acct.ShippingPostalCode;
            sampleRequest.Shipping_Country__c = acct.ShippingCountry;  
        
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