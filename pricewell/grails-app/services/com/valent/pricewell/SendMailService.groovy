package com.valent.pricewell
import java.util.Properties
import javax.mail.Message
import javax.mail.MessagingException
import javax.mail.PasswordAuthentication
import javax.mail.Session
import javax.mail.Transport
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware
import org.springframework.context.MessageSource
	
class SendMailService implements ApplicationContextAware {

	ApplicationContext applicationContext
    static transactional = true
	MessageSource messageSource
	SendMailTimer newTimer;
	
	def getPendingMail(SendMailTimer timer)
	{
		def inprogressList = PendingMail.findAll("FROM PendingMail pm WHERE pm.activeBit=1 AND pm.status='inprogress' ORDER BY createDate ASC")
		//println "inprogress mail : "+ inprogressList.size()
		if(inprogressList.size() == 0)
		{
			def pendingList = PendingMail.findAll("FROM PendingMail pm WHERE pm.activeBit=1 AND pm.status='pending' ORDER BY createDate ASC")
			
			if(pendingList.size() > 0)
			{
				for(int i=0; i<5 && i<pendingList.size(); i++)
				{
					def pendingMail =pendingList[i]
					pendingMail?.status = "inprogress"
					pendingMail.save()
					
				}
				println "converted inprogress"
				getProgressMail(timer)
			}
		}
		else
		{
			getProgressMail(timer)
		}
	}
	
	
	def getProgressMail(SendMailTimer timer)
	{
		newTimer = new SendMailTimer(timer.sendMailService)
		timer.push()
		def inprogressList = PendingMail.findAll("FROM PendingMail pm WHERE pm.activeBit=1 AND pm.status='inprogress' ORDER BY createDate ASC")
		println "sending mails : "+inprogressList.size()
		if(inprogressList.size() > 0)
		{
			for(PendingMail pm : inprogressList)
			{
				serviceMethod(pm.message, pm.subject, pm.emailId, pm.url)
				pm.active = false
				pm.status = "done"
				pm.activeBit = 0
				pm.save()
			}
			//newTimer = new SendMailTimer(this)
			newTimer.resume()
		}
	}
	
    def serviceMethod(String msg, String subject, String emailId, String url) 
	{
		
		Properties props = new Properties();
		File sowPropsFile = applicationContext.getResource("/props/email.properties").getFile();
		props.load(new FileReader(sowPropsFile));
		String username = props.getProperty("username");
		String password = props.getProperty("password");
		String fromEmail = props.getProperty("from");
		props.remove("username");
		props.remove("password");
		props.remove("from");
		
		
		Session session = Session.getInstance(props, new javax.mail.Authenticator() 
							{
									protected PasswordAuthentication getPasswordAuthentication() 
									{
										return new PasswordAuthentication(username,password)
									}
							})
 
		try {
 
			Message message = new MimeMessage(session)
			message.setFrom(new InternetAddress(fromEmail))
			//message.setRecipients(Message.RecipientType.TO,	InternetAddress.parse("abhi10901@gmail.com"))
			message.setRecipients(Message.RecipientType.TO,	InternetAddress.parse(emailId))
			//message.setSubject("Testing Subject")
			message.setSubject(subject)
			//message.setText("Dear Mail Crawler," + "\n\n No spam to my email, please!")
			setMessageSourceIfNull();
			String[] args = new String[4];
			args[0]=msg; 
			args[1]=subject;
			args[2]=url;
			args[3]= (subject.contains("Reset Password")) ? "Click Here to Reset Password" : "Check Out Here"
			String emailTemplate = messageSource.getMessage("email.template", args, "Default Message", Locale.getDefault());
			println emailTemplate;
			message.setContent(emailTemplate,"text/html") 
 
			Transport.send(message)
 
			System.out.println( "Mail sent to ${emailId}...");
 
		}
		catch (RuntimeException re) {
			println re.getMessage()
		}
		catch (MessagingException me) {
			println me.getMessage()
		}
    }
	
	void setMessageSourceIfNull(){
		if(messageSource == null){
			messageSource = applicationContext.getBean("messageSource") 
		}
	}
	
	List getMailByStatus(def status)
	{
		List mailList = new ArrayList()
		mailList = PendingMail.findAllByActiveBitAndStatus(0, status)
		println mailList
		println mailList.size()
		return mailList
	}
	
	
	void sendEmailNotification(String message, String subject, Collection receverList, String url)
	{
		String emailLists = ""
		
		int count = 1;
		for(User user in receverList)
		{
			if(user?.profile?.email != null)
			{
				//emailLists += user?.profile?.email + (receverList.size() > count? "," : "")
				
				//if(emailLists.length()>0)
				//{
					println user?.profile?.email
					
					def pendingMailInstance = new PendingMail()
					pendingMailInstance.message = message
					pendingMailInstance.subject = subject
					//pendingMailInstance.emailId = emailLists
					pendingMailInstance.emailId = user?.profile?.email
					pendingMailInstance.url = url
					pendingMailInstance.createDate = new Date()
					
					pendingMailInstance.save()
				//}

			}
			
			//count++;
		}
		
		
	}
}
