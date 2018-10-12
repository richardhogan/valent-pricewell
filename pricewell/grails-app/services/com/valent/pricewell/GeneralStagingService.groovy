package com.valent.pricewell
import org.apache.shiro.SecurityUtils;
class GeneralStagingService {

    static transactional = true

    def serviceCatalogService

    def changeStaging(Object object, Staging nextStage, String comment, GeneralStagingLog.StagingLogObjectType type) {
		GeneralStagingLog generalStagingLogInstance = logStagingModification(object, nextStage, object.stagingStatus, comment, type);
		
		object.stagingStatus = nextStage
		object.dateModified = new Date()
		object.currentStep = 1;
		
		if (object.save(flush:true)) {
			println "general staging created"
		}
		
		
		
    }
	
	
	/*def makeServiceInActive(Service service)
	{
		service.setActive(false);
		service.serviceProfile?.type = ServiceProfile.ServiceProfileType.INACTIVE;
		if(!service.save(flush:true))
		{
			return false;
		}
		return true;
	}
	*/
	private GeneralStagingLog logStagingModification(Object object, Staging nextStage, Staging fromStage, String comment, GeneralStagingLog.StagingLogObjectType type)
	{
		def generalStagingLogInstance = new GeneralStagingLog()
		generalStagingLogInstance.object = object
		generalStagingLogInstance.fromStage = fromStage
		generalStagingLogInstance.comment = comment
		generalStagingLogInstance.toStage = nextStage
		generalStagingLogInstance.action = ""
		generalStagingLogInstance.dateModified = new Date()
		generalStagingLogInstance.type = type
		//stagingLogInstance.revision = serviceProfile.revision
		def user = User.get(new Long(SecurityUtils.subject.principal))
		generalStagingLogInstance.modifiedBy = user?.username
		
		object.addToGeneralStagingLogs(generalStagingLogInstance)
		
		return generalStagingLogInstance
	}

}
