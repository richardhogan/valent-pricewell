package com.valent.pricewell

import javax.mail.PasswordAuthentication;
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

public class SendMail {

	MessageSource messageSource
	
	public void main()
	{
		Properties props = new Properties();
		props.setProperty("mail.smtp.host", "smtpout.secureserver.net")
		props.setProperty("mail.smtp.port", "80")
		props.setProperty("mail.smtp.auth", "true")
		
		String username = "rich@valent-software.com"
		String password = "windows95"
		String fromEmail = "notification@valent-software.com"
		
		
		
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
			message.setRecipients(Message.RecipientType.TO,	InternetAddress.parse("abhi10901@gmail.com"))
			//message.setRecipients(Message.RecipientType.TO,	InternetAddress.parse(emailId))
			message.setSubject("Testing Subject")
			//message.setSubject(subject)
			message.setText("Dear Mail Crawler," + "\n\n No spam to my email, please!")
			
 
			Transport.send(message)
 
			System.out.println( "Mail sent to abhi10901@gmail.com...");
 
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
	
}
