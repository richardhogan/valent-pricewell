package com.valent.pricewell

import java.util.Timer;
import java.util.TimerTask;
import org.apache.commons.logging.LogFactory
import org.apache.commons.logging.Log

class OpportunityExpireTimer extends TimerTask{

	private static final Log log = LogFactory.getLog(this)
	private static int counter= 0;
	OpportunityService opportunityService
	Timer timer = new Timer();
	
	public OpportunityExpireTimer(OpportunityService opportunityService){
		this.opportunityService = opportunityService;
	}
	
	public void init(){
		//Every 5 Seconds
		timer.schedule(this, 1000*60, 1000)//*60*60*6);
		println "opportunity expire timer start"
	}
	
	public void stop(){
		timer.cancel()
		println "opportunity expire timer cancel"
	}

	public void push(){
		this.timer.cancel();
		println "opportunity expire timer pushed"
	}
	
	public void resume(){
		//this.timer = new Timer();
		this.timer.schedule( this, 1000*60*60*6, 1000)//*60*60*6 );
		println "opportunity expire timer resumed, now run after every 6 hours"
	}
	
	public void run()
	{
		opportunityService.checkOpportunities(this)
		
	}

}
