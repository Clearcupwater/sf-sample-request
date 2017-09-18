public class UtilityBentley {
// class used to put random stuff to run tests and other processes
// Currently used in ForecastReminders.apxc to spoof system date
    
//  now     : getter/setter to have testemthod-driven different values for now; see also today
public static DateTime now      {get {return now == null ? DateTime.now() : now;} set;}

//  today : getter/setter to have testemthod-driven different values for today; see also now
public static Date today {get {return today == null ? Date.today() : today;} set;}

public static void SendEmail(String Subject, List<String> EmailsTo, List<String> EmailsCCs, String Body)  {
	system.debug('We are now in Utility Systems to send out an email');
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		list <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		mail.setReplyTo('Do_Not_Reply@bentleymills.com');
		mail.setSenderDisplayName('Bentley - Do Not reply');
		mail.setSubject(Subject);
		mail.setToAddresses(EmailsTo);
		mail.setCcAddresses(EmailsCCs);
		mail.setHtmlBody(Body);
		
		mails.add(mail);
        

       Messaging.sendEmail(mails);

}

public static String provideSampleRequestHeader(String SampleRequestId){
	Sample_Request_Item__c Sri = [Select SRI_Name__c, Stage__c, Sample_Request_Item_Type__c, Needed_By__c, Owner_Name__c, CreatedDate, Shipping_Account_Name__c, Shipping_Street__c, Shipping_State_Province__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c,
	Primary_Contact_First_Name__c, Primary_Contact_Last_Name__c, Primary_Contact_Phone_Number__c, Primary_Contact_Email__c, Application__c From Sample_Request_Item__c where id =:SampleRequestId];
	
	String body = 'Name: ' + sri.SRI_Name__c +'<br><br>'+
	'Stage: ' + sri.Stage__c +'<br>'+
	'Sample Request Item Type: ' + sri.Sample_Request_Item_Type__c+'<br>'+
	'Needed By: ' + sri.Needed_By__c +'<br>'+
	'Owner: ' + sri.Owner_Name__c +'<br>'+
	'CreatedDate: ' + sri.CreatedDate +'<br><br>'+
	'Shipping Account: ' + sri.Shipping_Account_Name__c +'<br>'+
	'Shipping Street: ' + sri.Shipping_Street__c +'<br>'+
	'Shipping State_Province: ' + sri.Shipping_State_Province__c +'<br>'+
	'Shipping Country: ' + sri.Shipping_Country__c +'<br>'+
	'Shipping Zip_Postal_Code: ' + sri.Shipping_Zip_Postal_Code__c +'<br><br>'+
	'Primary Contact First Name: ' + sri.Primary_Contact_First_Name__c +'<br>'+
	'Primary Contact Last Name: ' + sri.Primary_Contact_Last_Name__c +'<br>'+
	'Primary Contact Phone Number: ' + sri.Primary_Contact_Phone_Number__c +'<br>'+
	'Primary Contact Email: ' + sri.Primary_Contact_Email__c +'<br>';


	return body;
}

public static void provideLineItems (String SampleRequestId){
	
	/*            
Name__c       
Stage__c,
Sample_Request_Item_Type__c,
Needed_By__c,
To_Email__c,
Owner__c,
CreatedDate,
Shipping_Account__c,
Shipping_Street__c,
Shipping_State_Province__c,
Shipping_Country__c,
Shipping_Zip_Postal_Code__c,

Primary_Contact__c,
Primary_Contact_First_Name__c,
Primary_Contact_Last_Name__c,
Primary_Contact_Phone_Number__c,
Primary_Contact_Email__c,



        <apex:pageBlock id="SampleItems" title="Sample Details" >
        
        
        <apex:pageBlockSection title="Custom Sample" rendered="{!Sample_Request_Item__c.Sample_Request_Item_Type__c == 'Custom Sample'}" columns="1">
				<apex:pageBlockSectionItem >
                <apex:outputLabel value="Sample Details"/>
            	<apex:pageBlockTable value="{!Sample_Request_Item__c}" var="sr">
                    <apex:column headerValue="Style Description">
                        <apex:inputField style="width:300px" value="{!sr.Style_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Color Description">
                        <apex:inputField style="width:300px" value="{!sr.Color_Description__c}"/>
                    </apex:column>
                    
            	</apex:pageBlockTable>
        		</apex:pageBlockSectionItem>
            
                <br/>
            <apex:inputField value="{!Sample_Request_Item__c.Revision__c}"/>
            
            <br/>
            <apex:inputField value="{!Sample_Request_Item__c.Application__c}"/>
            <br/>
            <apex:inputField value="{!Sample_Request_Item__c.Has_Control_Sample__c}"/>
            <apex:inputField value="{!Sample_Request_Item__c.Light_Source__c}"/>
            <br/>
            <apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Revision_Notes__c}"/>
            <apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Additional_Comments__c}"/>
        </apex:pageBlockSection>
        
        <apex:pageBlockSection title="Custom Simulation" rendered="{!Sample_Request_Item__c.Sample_Request_Item_Type__c == 'Custom Simulation'}" columns="1">
        	<apex:pageBlockSectionItem >
                <apex:outputLabel value="Sample Details"/>
            	<apex:pageBlockTable value="{!Sample_Request_Item__c}" var="sr">
                    <apex:column headerValue="Style Description">
                        <apex:inputField style="width:200px" value="{!sr.Style_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Color Description">
                        <apex:inputField style="width:200px" value="{!sr.Color_Description__c}"/>
                    </apex:column>
                    

            	</apex:pageBlockTable>
        		</apex:pageBlockSectionItem>
            <br/>
            <apex:inputField value="{!Sample_Request_Item__c.Delivery_Method__c}"/>
            <apex:inputField value="{!Sample_Request_Item__c.Has_Control_Sample__c}"/>
            <apex:inputField value="{!Sample_Request_Item__c.Revision__c}"/>
            <apex:inputField value="{!Sample_Request_Item__c.Light_Source__c}"/>
            <br/>
            <apex:inputField value="{!Sample_Request_Item__c.Room_Scene__c}"/>
            <apex:inputField value="{!Sample_Request_Item__c.Simulation_Needs__c}"/>
            <apex:inputField value="{!Sample_Request_Item__c.Installation_Method__c}"/>
            <br/>
            <apex:inputField value="{!Sample_Request_Item__c.Field__c}"/>
            <apex:inputField value="{!Sample_Request_Item__c.Accent__c}"/>
            <apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Revision_Notes__c}"/>
            <apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Additional_Comments__c}"/>
            
        </apex:pageBlockSection>
                
        <apex:pageBlockSection title="Running Line Product Mockup" rendered="{!Sample_Request_Item__c.Sample_Request_Item_Type__c == 'Running Line Product Mockup'}" columns="1">
                	<apex:pageBlockSectionItem >
                <apex:outputLabel value="Sample Details"/>
            	<apex:pageBlockTable value="{!Sample_Request_Item__c}" var="sr">
                    <apex:column headerValue="Style Description">
                        <apex:inputField style="width:200px" value="{!sr.Style_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Color Description">
                        <apex:inputField style="width:200px" value="{!sr.Color_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Backing Size Tile/Bdlm">
                        <apex:inputField style="width:200px" value="{!sr.Backing_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Style Color">
                        <apex:inputField value="{!sr.Style_Color__c}"/>
                    </apex:column>
                    
            	</apex:pageBlockTable>
        		</apex:pageBlockSectionItem>
            <apex:inputField value="{!Sample_Request_Item__c.Total_Mockup_Size__c}"/>
            
            <br/>
            <apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Revision_Notes__c}"/>
            <apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Additional_Comments__c}"/>
            
        </apex:pageBlockSection>
        
		<apex:pageBlockSection title="Custom/Custom Color PDS Product Mockup" columns="1" rendered="{!Sample_Request_Item__c.Sample_Request_Item_Type__c == 'Custom/Custom Color PDS Production Trial'}">
            <apex:pageBlockSectionItem >
                <apex:outputLabel value="Sample Details"/>
            	<apex:pageBlockTable value="{!Sample_Request_Item__c}" var="sr">
                    <apex:column headerValue="Style Description">
                        <apex:inputField style="width:200px" value="{!sr.Style_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Color Description">
                        <apex:inputField style="width:200px" value="{!sr.Color_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Backing Size Tile/Bdlm">
                        <apex:inputField style="width:200px" value="{!sr.Backing_Description__c}"/>
                    </apex:column>
                    <apex:column headerValue="Style Color">
                        <apex:inputField value="{!sr.Style_Color__c}"/>
                    </apex:column>
            	</apex:pageBlockTable>
        		</apex:pageBlockSectionItem>
            
            	<apex:inputField value="{!Sample_Request_Item__c.Total_Mockup_Size__c}"/>
            	 <br/>
            		<apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Revision_Notes__c}"/>
            		<apex:inputField style="width:400px" value="{!Sample_Request_Item__c.Additional_Comments__c}"/>
            
            	
        </apex:pageBlockSection>
            
        

        </apex:pageBlock>
        
                
        <apex:pageBlock title="Approvals" rendered="{!if(Sample_Request_Item__c.id == null, false, true)}">
   			<apex:pageBlockSection >
            <apex:pageBlockSectionItem >
                <apex:outputLabel value="Details"/>
			    <apex:pageBlockTable value="{!Sample_Request_Item__c.Sample_Request_Item_Approvals__r}" var="sria">
                	<apex:column headerValue="Approval Order">
                        <apex:outputfield value="{!sria.Approval_Order__c}"/>
                    </apex:column>
                    <apex:column headerValue="User">
                        <apex:outputfield value="{!sria.User__c}"/>
                    </apex:column>
                    <apex:column headerValue="Id">
                        <apex:outputfield value="{!sria.id}"/>
                    </apex:column>
					<apex:column headerValue="Status">
                        <apex:outputfield value="{!sria.Status__c}"/>
                    </apex:column>
                    <apex:column headerValue="Emailed">
                        <apex:outputfield value="{!sria.Emailed__c}"/>
                    </apex:column>
                    <apex:column headerValue="Date Approved">
                        <apex:outputfield value="{!sria.Date_Approved__c}"/>
                    </apex:column>
                
                </apex:pageBlockTable>
            
            

            </apex:pageBlockSectionItem>     	
        	</apex:pageBlockSection>
        
        </apex:pageBlock>
        
        
        <apex:pageBlock title="Comment History" rendered="{!if(Sample_Request_Item__c.id == null, false, true)}">
        <apex:pageBlockButtons rendered="{if(printerFriendly == false, true, false)}">
        		<apex:commandButton value="{!if(Sample_Request_Item__c.Stage__c == 'Needing Additional Information','Respond to Request for Information','New Comment')}" action="{!newComment}"/>
        	</apex:pageBlockButtons>
        <apex:pageBlockSection >
            <apex:pageBlockSectionItem >
                <apex:outputLabel value="List"/>
			    <apex:pageBlockTable value="{!Sample_Request_Item__c.Sample_Request_Item_Comments__r}" var="sric" columnsWidth="500px,300px, 100px, 100px">
                	<apex:column headerValue="Comment">
                        <apex:outputfield value="{!sric.Comment__c}"/>
                    </apex:column>
                    <apex:column headerValue="Comment Reason">
                        <apex:outputfield value="{!sric.Comment_Reason__c}"/>
                    </apex:column>
                    <apex:column headerValue="Last Modified Date">
                    	<apex:outputField value="{!sric.LastModifiedDate}"/>
                    </apex:column>
                    <apex:column headerValue="Created Date">
                    	<apex:outputField value="{!sric.CreatedDate}"/>
                    </apex:column>
                </apex:pageBlockTable>
            </apex:pageBlockSectionItem>
        	</apex:pageBlockSection>
        </apex:pageBlock>

        
        
        
        
        

    </apex:form>
    
   	<apex:form enctype="multipart/form-data">
   		<apex:pageBlock title="Upload Attachment">
   			<apex:pageBlockButtons >
   				<apex:commandButton value="Save" action="{!upload}"/>
   				
   			</apex:pageBlockButtons>
   			
   			<apex:pageBlockSection showHeader="false" columns="2" id="block1">
   				<apex:pageBlockSectionItem >
   					<apex:outputLabel value="File Name" for="fileName"/>
         			<apex:inputText value="{!attachment.name}" id="fileName"/>
   				</apex:pageBlockSectionItem>
   					
   				<apex:pageBlockSectionItem >
   					<apex:outputLabel value="File" for="file"/>
   					<apex:inputFile value="{!attachment.body}" filename="{!attachment.name}" id="file"/>
   				</apex:pageBlockSectionItem>
   			
   				<apex:pageBlockSectionItem >
   					<apex:outputLabel value="Description" for="description"/>
          			<apex:inputTextarea value="{!attachment.description}" id="description"/>
   				</apex:pageBlockSectionItem>
   			
   			
   			</apex:pageBlockSection>
   			
   			
   			
   			
   		</apex:pageBlock>
   	
   	</apex:form>

</apex:page>

  
                    
                    
                    /*PageReference pdf = Page.getContentAsPDF();
                    pdf.getParameters().put('id', sri.id);
                    pdf.setRedirect(true);
                    
                    Blob b = pdf.getContent();
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName('attachment.pdf');
                    efa.setBody(b);
                    system.debug('We are now printing the pdf that comes out');                    
                    system.debug(b);
                    automaticApproval.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                    
                    
                    
                    //end of the pdf file setup
                    */
                  
			
	
}



}