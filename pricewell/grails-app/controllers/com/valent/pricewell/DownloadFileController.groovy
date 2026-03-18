package com.valent.pricewell
// MIGRATION (Nimble→Spring Security): removed Apache Shiro imports; using PricewellSecurity helper instead
import com.valent.pricewell.PricewellSecurity

class DownloadFileController {

    def index = { }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		//def user = PricewellSecurity.currentUser  // was: User.get(new Long(SecurityUtils.subject.principal))
		log.info(" ${actionUri} with params ${params}")
	}
	
	def downloadXmlFile = {
		def filePath = params.filePath
		def file = new File(filePath) //<-- you'll probably want to pass in the file name dynamically with the 'params' map
		
		response.setContentType("application/xml")
		response.setHeader("Content-disposition", "attachment;filename=${file.getName()}")
		response.outputStream << file.newInputStream()
	}
	
	def downloadDocumentFile = {
		
		def filePath = params.filePath
		def file = new File(filePath) //<-- you'll probably want to pass in the file name dynamically with the 'params' map
		
		response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
		response.setHeader("Content-disposition", "attachment;filename=${file.getName()}")
		response.outputStream << file.newInputStream()
	}
	
	def downloadPdfFile = {
		
	}
	
	def downloadTextFile = {
		def filePath = params.filePath
		def file = new File(filePath) //<-- you'll probably want to pass in the file name dynamically with the 'params' map
		
		response.setContentType("text/plain")
		response.setHeader("Content-disposition", "attachment;filename=${file.getName()}")
		response.outputStream << file.newInputStream()
	}
}
