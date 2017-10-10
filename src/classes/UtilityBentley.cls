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
	Sample_Request_Item__c Sri = [Select Sample_Request_Name__c, Stage__c, Sample_Request_Item_Type__c, Needed_By__c, Owner_Name__c, CreatedDate, Shipping_Account_Name__c, Shipping_Street__c, Shipping_State_Province__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c,
	Primary_Contact_First_Name__c, Primary_Contact_Last_Name__c, Primary_Contact_Phone_Number__c, Primary_Contact_Email__c, Application__c From Sample_Request_Item__c where id =:SampleRequestId];
	
	String body = 'Sample Request:' + sri.Sample_Request_Name__c +'<br><br>'+
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
	'Primary Contact Email: ' + sri.Primary_Contact_Email__c +'<br><br>';


	return body;
}

public static String provideLineItems (String SampleRequestId){
	
	Sample_Request_Item__c checkType = [Select SRI_Name__c,  Sample_Request_Item_Type__c From Sample_Request_Item__c where id =:SampleRequestId];
	String body;
	
	if(checkType.Sample_Request_Item_Type__c =='Custom Sample' ){
		Sample_Request_Item__c sri = [Select SRI_Name__c,  Sample_Request_Item_Type__c, Style_Description__c, Color_Description__c, Revision__c, Application__c, Has_Control_Sample__c, Light_Source__c, Revision_Notes__c, Additional_Comments__c From Sample_Request_Item__c where id =:SampleRequestId];
		
		body = 'Sample Request Number: ' + sri.SRI_Name__c +'<br><br>'+
		'Style Description: ' + sri.Style_Description__c +'<br>'+
		'Color Description: ' + sri.Color_Description__c +'<br>'+
		'Revision Number: ' + sri.Revision__c +'<br>'+
		'Application: ' + sri.Application__c +'<br>'+
		'Has Control Sample: ' + sri.Has_Control_Sample__c +'<br>'+
		'Light Source: ' + sri.Light_Source__c +'<br>'+
		'Revision Info: ' + sri.Revision_Notes__c +'<br>'+
		'Additional Comments: ' + sri.Additional_Comments__c +'<br>';	
	} 
	
	
	if(checkType.Sample_Request_Item_Type__c =='Custom Simulation' ){
		Sample_Request_Item__c sri = [Select SRI_Name__c,  Sample_Request_Item_Type__c, Style_Description__c,Color_Description__c, Delivery_Method__c,Has_Control_Sample__c,Revision__c, Light_Source__c,Room_Scene__c,Simulation_Needs__c,Installation_Method__c,Field__c, Accent__c, Revision_Notes__c,Additional_Comments__c From Sample_Request_Item__c where id =:SampleRequestId];
		
		body = 'Sample Request Number: ' + sri.SRI_Name__c +'<br><br>'+
		'Sample Request Item Type: ' + sri.Sample_Request_Item_Type__c +'<br>'+
		'Style Description: ' + sri.Style_Description__c +'<br>'+
		'Color Description: ' + sri.Color_Description__c +'<br>'+
		'Delivery Method: ' + sri.Delivery_Method__c +'<br>'+
		'Has Control Sample: ' + sri.Has_Control_Sample__c +'<br>'+
		'Revision Info: ' + sri.Revision__c +'<br>'+
		'Light Source: ' + sri.Light_Source__c +'<br>'+
		'Room Scene: ' + sri.Room_Scene__c +'<br>'+
		'Simulation Needs: ' + sri.Simulation_Needs__c +'<br>'+
		'Installation Method: ' + sri.Installation_Method__c +'<br>'+
		'Field: ' + sri.Field__c +'<br>'+
		'Accent: ' + sri.Accent__c +'<br>'+
		'Revision Notes: ' + sri.Revision_Notes__c +'<br>'+
		'Additional Comments: ' + sri.Additional_Comments__c +'<br>';
	}
	
	if(checkType.Sample_Request_Item_Type__c =='Running Line Product Mockup' ){
		Sample_Request_Item__c sri = [Select SRI_Name__c,  Sample_Request_Item_Type__c, Style_Description__c,Color_Description__c,Backing_Description__c,Style_Color__c, Total_Mockup_Size__c,Revision_Notes__c,Additional_Comments__c From Sample_Request_Item__c where id =:SampleRequestId];
		body = 'Sample Request Number: ' + sri.SRI_Name__c +'<br><br>'+
		'Sample Request Item Type: ' + sri.Sample_Request_Item_Type__c +'<br>'+
		'Sample Request Item Type: ' + sri.Style_Description__c+'<br>'+
		'Sample Request Item Type: ' + sri.Color_Description__c +'<br>'+
		'Sample Request Item Type: ' + sri.Backing_Description__c +'<br>'+
		'Sample Request Item Type: ' + sri.Style_Color__c +'<br>'+
		'Sample Request Item Type: ' + sri.Total_Mockup_Size__c +'<br>'+
		'Sample Request Item Type: ' + sri.Revision_Notes__c +'<br>'+
		'Sample Request Item Type: ' + sri.Additional_Comments__c +'<br>';
		
		
		
	} 
	
	if(checkType.Sample_Request_Item_Type__c =='Custom/Custom Color PDS Production Trial' ){
		Sample_Request_Item__c sri = [Select SRI_Name__c, Sample_Request_Item_Type__c, Style_Description__c, Color_Description__c, Style_Color__c, Total_Mockup_Size__c, Revision_Notes__c, Additional_Comments__c  From Sample_Request_Item__c where id =:SampleRequestId];
		 body = 'Sample Request Number: ' + sri.SRI_Name__c +'<br><br>'+
		'Sample Request Item Type: ' + sri.Sample_Request_Item_Type__c +'<br>'+
		'Style Description: ' + sri.Style_Description__c +'<br>'+
		'Color Description: ' + sri.Color_Description__c +'<br>'+
		'Style Color: ' + sri.Style_Color__c +'<br>'+
		'Total Mockup Size: ' + sri.Total_Mockup_Size__c +'<br>'+
		'Revision Notes: ' + sri.Revision_Notes__c +'<br>'+
		'Additional Comments: ' + sri.Additional_Comments__c +'<br>';

		
		
	}  
	return body;
	
}



}