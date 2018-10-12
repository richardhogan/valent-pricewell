package com.valent.pricewell.cw15

import com.valent.pricewell.*
import java.util.Timer;
import java.util.TimerTask;
import org.apache.commons.logging.LogFactory
import org.apache.commons.logging.Log
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.springframework.context.MessageSource

class SalesforceOpportunityImportTimer extends TimerTask{

	//This is the delay in milliseconds before task is to be executed
	private static final Long DELAY = 60*1000;
	
	//This is the time in milliseconds between successive task executions.
	private static final Long PERIOD = 1000;
	
	private static final Log log = LogFactory.getLog(this)
	private static int counter= 0;
	SfimportService sfimportService
	GrailsApplication  grailsApplication
	MessageSource messageSource
	Timer timer = new Timer();
	
	public SalesforceOpportunityImportTimer(SfimportService sfimportService, GrailsApplication  grailsApplication, MessageSource messageSource){
		this.sfimportService = sfimportService;
		this.grailsApplication = grailsApplication
		this.messageSource = messageSource
	}
	
	public void init(){
		timer.schedule(this, DELAY, PERIOD);
		println "salesforce opportunity import timer start"
	}
	
	public void stop(){
		timer.cancel()
		println "salesforce opportunity import timer cancel"
	}

	public void push(){
		this.timer.cancel();
		println "salesforce opportunity import timer pushed"
	}
	
	public void resume(){
		//this.timer = new Timer();
		this.timer.schedule( this, 1000*60*60*12, PERIOD);
		println "salesforce opportunity import timer resumed, now run after every 12 hrs"
	}
	
	public void run()
	{
		println "Sf opportunity import timer Run Method"
		sfimportService.importOpportunities(this)
	}

}
