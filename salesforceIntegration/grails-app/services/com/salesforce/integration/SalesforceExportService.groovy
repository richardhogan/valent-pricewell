package com.salesforce.integration

import java.net.MalformedURLException;
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import java.util.Date;
import java.util.Map;

import com.sforce.soap.partner.PartnerConnection;
import com.sforce.ws.ConnectorConfig
import com.sforce.ws.ConnectionException;

class SalesforceExportService {

    static transactional = true

	PartnerConnection partnerConnection = null;
	
    def serviceMethod() {

    }
	
	public Map isLogin(Map credentialsMap) {
		boolean result = false;
		String responseMessage = ""
		String username = credentialsMap["username"]//"ratan123@valent-software.com";//credentialMap["username"]//"check39@gmail.com";
		String password = credentialsMap["password"]+credentialsMap["securityToken"]////"Valent2010!1VcYFFtKwoJiINnSaglCUhedV";//credentialMap["password"]//"Valent2010!";
		String instanceUri  = credentialsMap["instanceUri"]//"na16.salesforce.com";//credentialMap["instanceUri"]
		String authEndPoint = "https://" + instanceUri + "/services/Soap/u/23.0";
		
		def storagePath = getStoragePath("salesforceLogs")

		try {
			ConnectorConfig config = new ConnectorConfig();
			
			config.setUsername(username);
			config.setPassword(password);
			config.setAuthEndpoint(authEndPoint);
			config.setTraceFile("${storagePath}/traceLogs.txt");
			config.setTraceMessage(true);
			config.setPrettyPrintXml(true);

			partnerConnection = new PartnerConnection(config);
			result = true;
			
		} catch (ConnectionException ce) {
			responseMessage = generateFailureMessage(ce.toString())
			//ce.printStackTrace();
			//println ce.toString()
			//println ce.getMessage()
		} catch (FileNotFoundException fnfe) {
			responseMessage = "Trace Log file not found."
		}
		
		return [result: result, responseMessage: responseMessage]
	}
	
	public String generateFailureMessage(String errorMessage)
	{
		if(errorMessage != null)
		{
			if(errorMessage.contains("Failed to send request"))
			{
				return "Invalid Instance URI. Please correct it first."
			}
			else if(errorMessage.contains("INVALID_LOGIN"))
			{
				return  "Invalid username, password, security token; or user locked out."
			}
		}
	}
	
	public List exportOpportunities(Map salesforceCredentialsMap, Date oldestDateAllowed)//from opportunity exporter
	{
		if(isLogin(salesforceCredentialsMap)['result'])
			return new SFOpportunityExporter(partnerConnection).exportOpportunities(oldestDateAllowed)
		else return []
	}
	
	public List getAccountFromId(Map salesforceCredentialsMap, String id)//from opportunity exporter
	{
		if(isLogin(salesforceCredentialsMap)['result'])
			return new SFAccountExporter(partnerConnection).getAccountFromId(id)
		else return []
	}
	
	public List getContactListFromAccountId(Map salesforceCredentialsMap, String id)//from opportunity exporter
	{
		if(isLogin(salesforceCredentialsMap)['result'])
			return new SFContactExporter(partnerConnection).getContactListFromAccountId(id)
		else return []
	}
	
	public String getProjectPath(def destinationDir)
	{
		def servletContext = ServletContextHolder.servletContext
		
		def projectPath = servletContext.getRealPath(destinationDir)//return path of the folder inside project
		//println "folder inside project path : "+projectPath
		File workingDir = new File(projectPath)
		
		projectPath = workingDir.getParent()//return path to web-app inside project
		//println "project path : "+projectPath
		workingDir = new File(projectPath)
		
		projectPath = workingDir.getParent()//return path to project
		//println "tomcat web-app path : "+projectPath
		
		//workingDir = new File(projectPath)
		//projectPath = workingDir.getParent()//return path to parent dir of project
		
		return projectPath.replaceAll('\\\\', '/')
	}
	
	public String getStoragePath(def destinationDirectory)
	{
		
		
		String workingDir = getProjectPath(destinationDirectory)//System.getProperty("user.dir")
		//File workingFile = new File(workingDir)
		//String projectPath = workingFile.getParent()//= workingDir.substring(0, workingDir.lastIndexOf("\\")).replaceAll('\\\\', '/')
		
		def storagePath = workingDir + "/" + "logs" + "/" + destinationDirectory
		storagePath = storagePath.replaceAll('\\\\', '/')
		
		def storagePathDirectory = new File(storagePath)
		if (!storagePathDirectory.exists())
		{
			print "CREATING DIRECTORY ${storagePath}: "
			if (storagePathDirectory.mkdirs())
			{
				println "SUCCESS"
			} else {
				println "FAILED"
			}
		}

		return "${storagePath}"
	}
}

