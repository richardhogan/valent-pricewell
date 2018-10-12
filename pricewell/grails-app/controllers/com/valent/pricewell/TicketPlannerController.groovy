package com.valent.pricewell

import grails.plugins.nimble.core.*

//import org.hibernate.collection.PersistentSet;


class TicketPlannerController {
	
    def list = {
		println'In List'
		def portfolioInstance = Portfolio.get(params.portfolioId)
		println params.parentTask
		if(params.parentTask != null) {
			def parentTaskId = TicketPlanner.get(params.parentTask)
			println "pt : " + parentTaskId
			println'In If Condition'
			TicketPlanner ticketPlannerInstance = new TicketPlanner()
			def ticketPlannerInstanceList = ticketPlannerInstance.findAll("From TicketPlanner WHERE portfolio_id = :portfolioId AND parent_task_id = :parentTaskId " ,[portfolioId: portfolioInstance,parentTaskId:parentTaskId]);
			render(view: "listsubtask", model:[portfolioInstance:portfolioInstance, ticketPlannerInstanceList:ticketPlannerInstanceList,parentTaskId:parentTaskId])
		} else{
		TicketPlanner ticketPlannerInstance = new TicketPlanner()
		def ticketPlannerInstanceList = ticketPlannerInstance.findAll("From TicketPlanner WHERE portfolio_id = :portfolioId AND parent_task_id = null " ,[portfolioId: portfolioInstance]);
		render(view: "listsetup", model:[portfolioInstance:portfolioInstance, ticketPlannerInstanceList:ticketPlannerInstanceList])
		}
    }
	
	def create = {
		println'In Create'
		def portfolioInstance = Portfolio.get(params.portfolioId.toLong())
		println "id " + portfolioInstance
		println 'parentTask : ' + params.parentTask
		if(params.parentTask != null) {
			//println 'In If' + params.parentTask + 'Or' + params.parentTask
			def parentTaskId = TicketPlanner.get(params.parentTask.toLong())
			render(view: "createsubtask", model:[portfolioInstance:portfolioInstance, parentTaskId:parentTaskId]);
		}else{
			render(view: "createsetup", model:[portfolioInstance:portfolioInstance]);
		}
	}   
	
	def save = {
		println"In Save"
		println 'params : ' + params
		def ticketPlannerInstance = new TicketPlanner();
		ticketPlannerInstance.taskName = params.taskName
		ticketPlannerInstance.taskDesc = params.taskDesc
		ticketPlannerInstance.portfolio = Portfolio.get(params.portfolioId.toLong());
		println'parent task : ' + params.parentTask
		if(params.parentTask != null) {
			println'In If'
			ticketPlannerInstance.parentTask = TicketPlanner.get(params.parentTask.toLong())
			println ticketPlannerInstance
			if(ticketPlannerInstance.save(flush:true))
			{
				println 'In success'
				render "success"
			}
			else{
				println 'In failure'
				render "failure"
			}
		}else{
			ticketPlannerInstance.parentTask = null
			println ticketPlannerInstance
			if(ticketPlannerInstance.save(flush:true))
			{
				println 'In success'
				render "success"
			}
			else{
				println 'In failure'
				render "failure"
			}
		}
	}
	def edit = {
		println'In Edit'
		def ticketPlannerInstance = TicketPlanner.get(params.id)
		println "Test: " +ticketPlannerInstance
		def portfolioInstance = Portfolio.get(params.portfolioId)
		println "id " + portfolioInstance
		println'parent task : ' + params.parentTask;
		if(params.parentTask != null) {
			println'In If'
			def parentTaskId = TicketPlanner.get(params.parentTask)
			render(view: "editsubtask", model:[ticketPlannerInstance:ticketPlannerInstance,portfolioInstance:portfolioInstance,parentTaskId:parentTaskId]);
		}
		else{
			render(view: "editsetup", model:[ticketPlannerInstance:ticketPlannerInstance,portfolioInstance:portfolioInstance]);
		}
	}
	def update = {
		println "In update"
		def ticketPlannerInstance = TicketPlanner.get(params.id)
		if (ticketPlannerInstance) {
			if (params.version) {
				def version = params.version.toLong()
				def taskName = params.taskName.toString()
				if (ticketPlannerInstance.version > version) {
					ticketPlannerInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'TicketPlanner.label', default: 'TicketPlanner')] as Object[], "Another user has updated this TicketPlanner while you were editing")
					render(view: "editsetup", model: [ticketPlannerInstance: ticketPlannerInstance])
					return
				}
			}
			def oldName = ticketPlannerInstance?.taskName
			ticketPlannerInstance.taskName = params.taskName
			ticketPlannerInstance.taskDesc = params.taskDesc
			ticketPlannerInstance.portfolio = Portfolio.get(params.portfolioId);
			println'parent task : ' + params.parentTask;
			if(params.parentTask != null) {
				println'In If'
				ticketPlannerInstance.parentTask = TicketPlanner.get(params.parentTask.toLong())
				println "Test" + ticketPlannerInstance
				if(ticketPlannerInstance.save(flush:true))
				{
					println 'In success'
					render "success"
				}
				else{
					println 'In failure'
					render "failure"
				}
			}else{
				ticketPlannerInstance.parentTask = null
				if (!ticketPlannerInstance.hasErrors() && ticketPlannerInstance.save(flush: true))
				{
					render "success"
				}
				else
				{
					if(params.source == "setup" || params.source == "firstsetup")
					{
						render generateAJAXError(ticketPlannerInstance);
					}
					else
					{
						render(view: "editsetup", model: [ticketPlannerInstance: ticketPlannerInstance])
					}
				}
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'SolutionBundle.label', default: 'SolutionBundle'), params.id])}"
			redirect(action: "listsetup")
		}
	}
	def getTaskName = {
		def ticketPlannerInstance = TicketPlanner.get(params.id)
		render ticketPlannerInstance.taskName
	}
	private String generateAJAXError(Object obj){
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		if(obj.hasErrors()){
			obj.errors.each {
				sb.append("<li>${it}</li>")
			}
		}
		sb.append("</ul>");
	}
	def deletesetup = {
		println 'In delete setup '
		def ticketPlannerInstance = TicketPlanner.get(params.id)
		println'id : ' + ticketPlannerInstance
		if (ticketPlannerInstance) 
		{
			try
			{
				println'In try'
				ticketPlannerInstance.delete(flush: true)
				render "success";
			}
			catch(Exception e) 
			{
				println "In catch"
				render "fail";
			}
		}
	}
}