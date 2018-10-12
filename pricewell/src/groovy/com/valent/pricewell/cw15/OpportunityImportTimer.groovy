package com.valent.pricewell.cw15

import com.valent.pricewell.*
import java.util.Timer;
import java.util.TimerTask;
import org.apache.commons.logging.LogFactory
import org.apache.commons.logging.Log
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.springframework.context.MessageSource

class OpportunityImportTimer extends TimerTask{

	private static final Log log = LogFactory.getLog(this)
	private static int counter= 0;
	CwimportService cwimportService
	GrailsApplication  grailsApplication
	MessageSource messageSource
	Timer timer = new Timer();
	
	public OpportunityImportTimer(CwimportService cwimportService, GrailsApplication  grailsApplication, MessageSource messageSource){
		this.cwimportService = cwimportService;
		this.grailsApplication = grailsApplication
		this.messageSource = messageSource
	}
	
	public void init(){
		timer.schedule(this, 1000*90, 1000)//*60*60*6);
		println "opportunity import timer start"
	}
	
	public void stop(){
		timer.cancel()
		println "opportunity import timer cancel"
	}

	public void push(){
		this.timer.cancel();
		println "opportunity import timer pushed"
	}
	
	public void resume(){
		//this.timer = new Timer();
		this.timer.schedule( this, 1000*60*60*2, 1000)//*60*60*6 );
		println "opportunity import timer resumed, now run after every 12 hours"
	}
	
	public void run()
	{
		cwimportService.importOpportunities(this)
		
	}

}
