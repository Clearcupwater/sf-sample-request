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



}