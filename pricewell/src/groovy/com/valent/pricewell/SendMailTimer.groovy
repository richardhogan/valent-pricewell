package com.valent.pricewell

import java.util.TimerTask;
import java.util.Timer;
import org.apache.commons.logging.LogFactory
import org.apache.commons.logging.Log
//import com.valent.pricewell.ServiceStagingServic

public class SendMailTimer extends TimerTask {
	private static final Log log = LogFactory.getLog(this)
	private static int counter= 0;
	SendMailService sendMailService
	Timer timer = new Timer();
	
	public SendMailTimer(SendMailService sendMailService){
		this.sendMailService = sendMailService;
	}
	
	public void init(){
		//Every 5 Seconds
		timer.schedule(this, 1000*10, 1000 * 10);
		println "timer start"
	}
	
	public void stop(){
		timer.cancel()
		println "timer cancel"
	}

	public void push(){
		this.timer.cancel();
		println "timer pushed"
	}
	
	public void resume(){
		//this.timer = new Timer();
		this.timer.schedule( this, 1000*10, 1000 * 10 );
		println "timer resume"
	}
	
	public void run()
	{
		//log.info("Send Mail Timer.. counter:" + counter++);
		//sendMailService()
		sendMailService.getPendingMail(this)
		//cls.getClass()
	}
	
	

}
