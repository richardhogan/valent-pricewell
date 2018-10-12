package com.valent.pricewell

import org.apache.shiro.SecurityUtils;

import com.valent.pricewell.ServiceProfile.ServiceProfileType;

class ServiceStagingService {

    static transactional = false
	def serviceCatalogService

    def changeStaging(ServiceProfile serviceProfile, Staging nextStage, String comment) {
		StagingLog stagingLogInstance = logStagingModification(serviceProfile, nextStage, serviceProfile.stagingStatus, comment);
		
		serviceProfile.stagingStatus = nextStage
		serviceProfile.dateModified = new Date()
		serviceProfile.currentStep = 1;
		
		if(nextStage.types.contains(Staging.StagingType.END_EDIT) || nextStage.types.contains(Staging.StagingType.END_NEW))
		{
			serviceProfile.type = ServiceProfileType.PUBLISHED
			serviceProfile.datePublished = new Date()
			
			if(!serviceProfile.service?.serviceProfile?.equals(serviceProfile))
			{
				assignServiceToNewProfile(serviceProfile)
				//serviceProfile.service.serviceProfile = serviceProfile
				
			}
		}
		else if(nextStage.types.contains(Staging.StagingType.END_REMOVE))
		{
			serviceProfile.type = ServiceProfileType.INACTIVE
		}
		else
		{
			serviceProfile.type = ServiceProfileType.DEVELOP
		}
		
		if (serviceProfile.save(flush:true)) {
			if(serviceProfile.type == ServiceProfileType.PUBLISHED)
			{
				serviceCatalogService.updateServiceToPricelist(serviceProfile)
			}
		}
		
    }
	
	public assignServiceToNewProfile(ServiceProfile currentProfile)
	{
		ServiceProfile oldProfile = ServiceProfile.get(currentProfile?.oldProfile?.id)
		oldProfile.stagingStatus = Staging.findByName("inActive")
		oldProfile.type = ServiceProfile.ServiceProfileType.INACTIVE
		if(!oldProfile.save(flush:true))
		{
			return false;
		}
		Service service = Service.get(oldProfile.service.id)
		service.serviceProfile = currentProfile
		if(!isProfileAvailableInService(service, currentProfile))
		{
			service.addToProfiles(currentProfile)
		}
		service.dateModified = new Date()
		service.save()
		
	}
	
	public boolean isProfileAvailableInService(Service service, ServiceProfile serviceProfile)
	{
		for(ServiceProfile sp : service?.profiles)
		{
			if(sp?.id == serviceProfile?.id)
				return true
		}
		return false
	}

	def makeServiceInActive(Service service)
	{
		service.setActive(false);
		def newStage = Staging.findByName("inActive")
		service.serviceProfile?.stagingStatus = newStage
		service.serviceProfile?.type = ServiceProfile.ServiceProfileType.INACTIVE;
		if(!service.save(flush:true))
		{
			return false;
		}
		return true;
	}
	
	def makeServiceProfileInActive(ServiceProfile serviceProfile)
	{
		serviceProfile.service.setActive(false);
		def newStage = Staging.findByName("inActive")
		serviceProfile.stagingStatus = newStage
		serviceProfile.type = ServiceProfile.ServiceProfileType.INACTIVE;

		if(!serviceProfile.save(flush:true))
		{
			return false;
		}
		return true;
	}
	
	private StagingLog logStagingModification(ServiceProfile serviceProfile, Staging nextStage, Staging fromStage, String comment)
	{
		def stagingLogInstance = new StagingLog()
		stagingLogInstance.fromStage = fromStage
		stagingLogInstance.comment = comment
		stagingLogInstance.toStage = nextStage
		stagingLogInstance.action = ""
		stagingLogInstance.dateModified = new Date()
		stagingLogInstance.revision = serviceProfile.revision
		def user = User.get(new Long(SecurityUtils.subject.principal))
		stagingLogInstance.modifiedBy = user?.username
		
		serviceProfile.addToStagingLogs(stagingLogInstance)
		
		return stagingLogInstance
	}
}
